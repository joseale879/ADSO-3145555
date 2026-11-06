from __future__ import annotations

from html import escape
from io import BytesIO
from pathlib import Path
from urllib.parse import urlparse

import markdown
from xhtml2pdf import pisa


ROOT = Path(__file__).resolve().parents[1]
DELIVERY = ROOT / "04-final-delivery" / "07-hidro-smart"
CUT_DATE = "2026-11-05"
SOURCE_LABEL = "PT_HS/main | 32be1cf"

CSS = """
@page {
  size: A4;
  margin: 18mm 18mm 19mm 18mm;
  @frame footer_frame {
    -pdf-frame-content: footer;
    left: 18mm;
    width: 174mm;
    top: 279mm;
    height: 9mm;
  }
}
body {
  font-family: Helvetica, sans-serif;
  font-size: 9pt;
  line-height: 1.28;
  color: #243247;
}
p { margin: 4pt 0 7pt; }
a { color: #1d4ed8; text-decoration: none; }
h1, h2, h3, h4 {
  color: #173b80;
  -pdf-keep-with-next: true;
}
h1 { font-size: 20pt; margin: 14pt 0 8pt; }
h2 { font-size: 15pt; margin: 14pt 0 7pt; }
h3 { font-size: 11.5pt; margin: 10pt 0 5pt; }
h4 { font-size: 10pt; margin: 8pt 0 4pt; }
strong { color: #182a45; }
blockquote {
  border-left: 3pt solid #2563eb;
  background-color: #f4f8ff;
  color: #3d536f;
  margin: 4pt 0 12pt;
  padding: 7pt 9pt;
}
ul, ol { margin: 4pt 0 8pt; padding-left: 18pt; }
li { margin: 0 0 4pt; }
table {
  width: 100%;
  font-size: 7.3pt;
  margin: 8pt 0 10pt;
}
th, td {
  border: 0.5pt solid #cbd5e1;
  padding: 4pt 5pt;
  vertical-align: top;
}
th { background-color: #eaf1fb; color: #173b80; }
tr { -pdf-keep-with-next: false; }
pre {
  font-family: Courier;
  font-size: 7.2pt;
  background-color: #f3f5f8;
  border: 0.5pt solid #d7dee8;
  padding: 6pt;
  white-space: pre-wrap;
}
code { font-family: Courier; font-size: 8pt; }
hr { border: 0; border-top: 0.5pt solid #d8e1ed; }
.cover { padding-top: 8mm; }
.cover-brand { font-size: 9pt; color: #2563eb; margin-bottom: 29mm; }
.cover-title { color: #173b80; font-size: 25pt; line-height: 1.1; margin: 0 0 8pt; }
.cover-subtitle { color: #526984; font-size: 13pt; margin: 0 0 18pt; }
.cover-status {
  color: #7a5200;
  background-color: #fff3cd;
  border: 0.7pt solid #e8bb43;
  padding: 6pt 9pt;
  font-size: 8pt;
  width: 72mm;
  margin: 0 0 18pt;
}
.cover-meta { color: #526984; font-size: 8pt; line-height: 1.5; }
#footer {
  border-top: 0.5pt solid #cbd5e1;
  color: #64748b;
  text-align: center;
  font-size: 7pt;
  padding-top: 2.5pt;
}
"""


def render_markdown(source: Path) -> str:
    text = source.read_text(encoding="utf-8-sig")
    return markdown.markdown(
        text,
        extensions=["tables", "fenced_code", "sane_lists"],
        output_format="html",
    )


def callback_for(sources: list[Path]):
    source_dirs = [source.parent for source in sources]

    def resolve(uri: str, rel: str | None = None) -> str:
        parsed = urlparse(uri)
        if parsed.scheme in {"http", "https", "data", "mailto"} or uri.startswith("#"):
            return uri
        for base in source_dirs:
            candidate = (base / uri).resolve()
            if candidate.exists():
                return str(candidate)
        return uri

    return resolve


def build_pdf(
    *,
    output: Path,
    title: str,
    category: str,
    sources: list[Path],
    breaks: set[int] | None = None,
) -> None:
    breaks = breaks or set()
    body_parts: list[str] = []
    for index, source in enumerate(sources):
        if index in breaks:
            body_parts.append("<pdf:nextpage />")
        body_parts.append(render_markdown(source))

    cover = f"""
    <div class="cover">
      <div class="cover-brand">HIDRO SMART · ENTREGA DE PROYECTO FORMATIVO</div>
      <h1 class="cover-title">{escape(title)}</h1>
      <p class="cover-subtitle">Documento de trabajo para revisión del equipo</p>
      <div class="cover-status">Borrador de revisión · no es versión aprobada</div>
      <div class="cover-meta">
        Corte documental: {CUT_DATE}<br />
        Fuente funcional acordada: {escape(SOURCE_LABEL)}<br />
        Carpeta: {escape(category)}
      </div>
    </div>
    <pdf:nextpage />
    """

    substitutions = {
        chr(0x25CF): "- ",
        chr(0x2022): "- ",
        chr(0xF0B7): "- ",
        chr(0x2192): " -> ",
        chr(0x2193): " (down) ",
        chr(0x2265): ">=",
        chr(0x2264): "<=",
        chr(0x2011): "-",
        chr(0x2013): "-",
        chr(0x2014): "-",
        chr(0x2212): "-",
    }

    html = f"""<!DOCTYPE html>
    <html><head><meta charset="utf-8" /><style>{CSS}</style></head>
    <body>
      <div id="footer">Hidro Smart · Borrador de revisión · {CUT_DATE}</div>
      {cover}
      {''.join(body_parts)}
    </body></html>"""

    # Use readable ASCII equivalents for symbols missing from PDF core fonts.
    for source_symbol, pdf_text in substitutions.items():
        html = html.replace(source_symbol, pdf_text)

    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("wb") as stream:
        result = pisa.CreatePDF(
            BytesIO(html.encode("utf-8")),
            dest=stream,
            encoding="utf-8",
            link_callback=callback_for(sources),
        )
    if result.err:
        raise RuntimeError(f"xhtml2pdf reported {result.err} error(s) for {output}")


documents = [
    {
        "output": "01-requirements-specification/requirements-specification.pdf",
        "title": "Especificación de requisitos",
        "category": "01-requirements-specification",
        "sources": [
            "01-requirements-specification/requirements-specification.md",
            "01-requirements-specification/requirements-matrix.md",
        ],
        "breaks": {1},
    },
    {
        "output": "04-software-design/software-design.pdf",
        "title": "Diseño del software",
        "category": "04-software-design",
        "sources": ["04-software-design/software-design.md"],
    },
    {
        "output": "05-test-documentation/test-documentation.pdf",
        "title": "Documentación de pruebas",
        "category": "05-test-documentation",
        "sources": [
            "05-test-documentation/test-plan-results.md",
            "05-test-documentation/ci-evidence.md",
        ],
        "breaks": {1},
    },
    {
        "output": "07-improvement-actions/improvement-actions.pdf",
        "title": "Acciones correctivas, preventivas y de mejora",
        "category": "07-improvement-actions",
        "sources": ["07-improvement-actions/corrective-preventive-actions.md"],
    },
    {
        "output": "08-manuals/manuals.pdf",
        "title": "Manuales de Hidro Smart",
        "category": "08-manuals",
        "sources": [
            "08-manuals/technical-manual.md",
            "08-manuals/installation-manual.md",
            "08-manuals/user-manual.md",
        ],
        "breaks": {1, 2},
    },
    {
        "output": "09-project-article/project-article.pdf",
        "title": "Artículo del proyecto",
        "category": "09-project-article",
        "sources": ["09-project-article/project-article.md"],
    },
]


def main() -> None:
    for document in documents:
        sources = [DELIVERY / path for path in document["sources"]]
        output = DELIVERY / document["output"]
        build_pdf(
            output=output,
            title=document["title"],
            category=document["category"],
            sources=sources,
            breaks=document.get("breaks"),
        )
        print(f"Generated {output.relative_to(ROOT)}")


if __name__ == "__main__":
    main()