> **Estado y alcance.** Documento en revisión para la entrega. Las fechas, cifras y funciones heredadas del documento fuente solo se consideran vigentes cuando están respaldadas por evidencia del monorepo PT_HS. Consulta el [índice de entrega](../README.md) y el [estado del borrador](../delivery-draft-status.md).


<strong>INFORME TÉCNICO-ECONÓMICO</strong>

<strong>PROYECTO: HIDRO SMART</strong>

<strong>INTEGRANTES:</strong>

Emerson Calet Molano Cardozo

José David Amaya Mosquera

José Alejandro Montealegre Rodríguez

<strong>INSTRUCTOR:</strong>

MOTTA VARGAS JOSÉ DE JESÚS

SERVICIO NACIONAL DE APRENDIZAJE – SENA

PROGRAMACIÓN DE SOFTWARE – 3145555

<strong>2025</strong>


<strong>1. RESUMEN EJECUTIVO</strong>


La propuesta académica de Hidro Smart (2025) planteó monitorear el consumo de agua en hogares mediante sensores IoT, conectividad Wi-Fi/Bluetooth y una aplicación. Este informe conserva ese planteamiento; la implementación y su validación se describen en los documentos de estado y pruebas.


Su propósito es ayudar a los hogares a observar su consumo de agua y detectar usos inusuales. Las metas de ahorro, seguridad, escalabilidad y recomendaciones personalizadas son objetivos de la propuesta y no resultados medidos en este informe.


En el plano económico, la fuente académica presenta una inversión estimada de $ 80.305.000 COP (sin equipos personales) y un potencial de ahorro del 15 % al 25 % anual por hogar. Son hipótesis originales de 2025: no se recalcularon ni se midieron con usuarios, por lo que no demuestran viabilidad financiera ni ahorro real.


-<strong>Nombre del proyecto</strong><strong>:</strong> <strong>Hidro Smart – Sistema de Monitoreo Inteligente del Agua</strong><strong>.</strong>

<strong>-</strong><strong>Tipo de solución</strong><strong>: </strong><strong>Aplicación móvil multiplataforma + dispositivos </strong><strong>IoT</strong><strong> + </strong><strong>backend</strong><strong> en la nube</strong>

<strong>-</strong><strong>Plataforma objetivo</strong><strong>: </strong><strong>Android 9 o superior (hasta Android 14) / Navegadores web (Chrome, Edge, Firefox)</strong>

<strong>- Stack técnico observado en el repositorio: React/Vite/TypeScript web; Expo/React Native móvil; Node.js/Express; PostgreSQL/Liquibase; firmware ESP32 en C++/Arduino; Flespi MQTT con TLS para la integración externa y Mosquitto para desarrollo local. La validación de la versión final queda pendiente.</strong>

<strong>-</strong><strong>Presupuesto total</strong><strong>: </strong><strong>$ 80.305.000 COP (operativo) \| $ 110.595.000 COP (incluyendo equipos de desarrollo)</strong>

<strong>-</strong><strong>Duración del proyecto</strong><strong>: </strong><strong>6 meses – Metodología ágil Scrum (</strong><strong>sprints</strong><strong> de 2 semanas)</strong>


<strong>2. INTRODUCCIÓN</strong>


El acceso al agua potable y la gestión eficiente del recurso hídrico son desafíos prioritarios en Colombia. Según datos de la Personería de Bogotá (2024), hasta el 40% del agua potable se pierde en la capital, y a nivel nacional esta cifra asciende al 48% (Universidad de los Andes, 2024). A su vez, el DANE (2024) estima que solo el 33% de los ciudadanos adopta prácticas de ahorro hídrico.


Esta problemática evidencia la urgente necesidad de soluciones tecnológicas accesibles que permitan a los hogares conocer, controlar y optimizar su consumo diario. Los medidores convencionales únicamente registran el total mensual sin ofrecer desglose por actividad, lo que impide la toma de decisiones informadas.


Hidro Smart surge como respuesta innovadora a esta necesidad. El sistema combina sensores IoT de caudal con una aplicación móvil que muestra el consumo en tiempo real, clasificado por actividad doméstica (ducha, lavado, cocina, aseo), y genera alertas y recomendaciones personalizadas para fomentar el uso responsable del agua.


Este documento consolida los aspectos técnicos y económicos del desarrollo: requerimientos del sistema, arquitectura tecnológica, recursos humanos, presupuesto detallado, cronograma, plan de mantenimiento, impacto ambiental y análisis de viabilidad del proyecto.


<strong>3. DESCRIPCIÓN DEL PROYECTO</strong>


Hidro Smart es un sistema inteligente de monitoreo hídrico compuesto por tres capas tecnológicas integradas:


<p>• Capa de sensores IoT: dispositivos de medición de caudal conectados vía Wi-Fi o Bluetooth que capturan datos de consumo en tiempo real y los transmiten al servidor mediante protocolos seguros.</p>
<p>• Capa de backend e integración: API REST en Node.js/Express con persistencia PostgreSQL/Liquibase. El flujo de telemetría usa MQTT; Flespi/TLS aparece configurado para la integración externa y Mosquitto se documenta como broker de desarrollo local. La operación completa debe validarse de nuevo sobre el tag de entrega.</p>
<p>• Capa de aplicación móvil/web: interfaz multiplataforma desarrollada en React/Vite web; Expo/React Native con WebView para móvil (JavaScript) para Android 9 o superior (hasta Android 14), y versión web compatible con Chrome, Edge y Firefox, que permite al usuario visualizar estadísticas, configurar alertas, gestionar hogares y descargar reportes en PDF o Excel.</p>

El sistema soporta tres tipos de usuarios con roles diferenciados: Administrador (supervisa hogares y dispositivos), Soporte Técnico (mantenimiento IoT y calibraciones) y Usuario Doméstico (monitorea consumo y sigue recomendaciones). La gestión de accesos se controla mediante autenticación segura con tokens JWT (Access y Refresh), cifrado AES-256 y comunicaciones HTTPS/TLS.


<strong>4. OBJETIVOS</strong>


<strong>4.1 Objetivo General</strong>

Desarrollar e implementar un sistema IoT para el monitoreo y control inteligente del consumo de agua en hogares colombianos, mejorando la eficiencia hídrica, reduciendo el desperdicio y fomentando hábitos sostenibles mediante tecnología móvil accesible.


<strong>4.2 Objetivos Específicos</strong>

<p>1\. Desarrollar una aplicación móvil multiplataforma (Android 9 o superior (hasta Android 14)) que muestre datos de consumo en tiempo real desde sensores IoT.</p>
<p>2\. Registrar, procesar y clasificar el consumo de agua por actividad doméstica (ducha, lavado, cocina, aseo).</p>
<p>3\. Generar gráficos comparativos y reportes periódicos (diario, semanal, mensual, anual) en formato PDF y Excel.</p>
<p>4\. Implementar un modelo predictivo de consumo basado en historial registrado.</p>
<p>5\. Proporcionar alertas automáticas y recomendaciones personalizadas de ahorro hídrico.</p>
<p>6\. Integrar infraestructura en la nube con disponibilidad mínima del meta propuesta no medida y cifrado de extremo a extremo.</p>
<p>7\. Evaluar el impacto económico y ambiental del sistema durante su fase piloto.</p>

<strong>5. ALCANCE Y METODOLOGÍA</strong>


<strong>5.1 Alcance del Sistema</strong>

El sistema Hidro Smart, según lo definido en el SRS, abarca los siguientes módulos funcionales:

<p>• Módulo RF1 – Autenticación y gestión de usuarios: registro, inicio de sesión seguro, tokens JWT, recuperación de contraseña, roles y suspensión de cuentas.</p>
<p>• Módulo RF2 – Gestión de dispositivos IoT: registro de sensores, asignación de ID único, suspensión y reactivación de dispositivos.</p>
<p>• Módulo RF3 – Proyectos / Hogares: creación de hogares con estratificación, asignación de usuarios titulares/miembros y dispositivos.</p>
<p>• Módulo RF4 – Configuraciones del sistema: topes de consumo, alertas, recomendaciones, idiomas, moneda y controles de auditoría.</p>
<p>• Módulo RF5 – Reportes y análisis: gráficos en tiempo real, históricos, hábitos de consumo, modelo predictivo, alertas y proyectos asociados al usuario.</p>

El sistema no incluirá en su versión inicial integración con redes externas de servicios públicos, pero quedará preparado para futuras extensiones. Compatibilidad confirmada: Android 9–14 y navegadores Chrome, Edge, Firefox y Opera.


<strong>5.2 Metodología de Desarrollo</strong>

El proyecto se desarrolla bajo el enfoque ágil Scrum, organizado en sprints de 2 semanas con ceremonias de revisión, retrospectiva y planificación. Las fases principales son:


<table>
<tr>
<td><p><strong>Fase</strong></p></td>
<td><p><strong>Actividad Principal</strong></p></td>
<td><p><strong>Sprint</strong></p></td>
<td><p><strong>Duraci&#243;n</strong></p></td>
</tr>
<tr>
<td><p>1</p></td>
<td><p>An&#225;lisis de requerimientos y documentaci&#243;n SRS</p></td>
<td><p>Sprint 1</p></td>
<td><p>2 semanas</p></td>
</tr>
<tr>
<td><p>2</p></td>
<td><p>Dise&#241;o t&#233;cnico, arquitectura y prototipado Figma</p></td>
<td><p>Sprint 2</p></td>
<td><p>2 semanas</p></td>
</tr>
<tr>
<td><p>3</p></td>
<td><p>Desarrollo frontend m&#243;vil y web (RF1–RF3)</p></td>
<td><p>Sprint 3–4</p></td>
<td><p>4 semanas</p></td>
</tr>
<tr>
<td><p>4</p></td>
<td><p>Desarrollo backend, IoT, base de datos (RF4–RF5)</p></td>
<td><p>Sprint 5–6</p></td>
<td><p>4 semanas</p></td>
</tr>
<tr>
<td><p>5</p></td>
<td><p>Pruebas, validaci&#243;n, correcciones y QA</p></td>
<td><p>Sprint 7</p></td>
<td><p>2 semanas</p></td>
</tr>
<tr>
<td><p>6</p></td>
<td><p>Implementaci&#243;n piloto, entrega y documentaci&#243;n final</p></td>
<td><p>Sprint 8</p></td>
<td><p>2 semanas</p></td>
</tr>
</table>


<strong>6. PROPUESTA TÉCNICA</strong>


<strong>6.1 Arquitectura del Sistema</strong>

La arquitectura de Hidro Smart sigue un modelo de tres capas (Dispositivo – Servidor – Cliente) con los siguientes componentes:


<table>
<tr>
<td><p><strong>Capa</strong></p></td>
<td><p><strong>Componente</strong></p></td>
<td><p><strong>Tecnolog&#237;a / Herramienta</strong></p></td>
<td><p><strong>Funci&#243;n</strong></p></td>
</tr>
<tr>
<td><p>Dispositivo IoT</p></td>
<td><p>Sensor de caudal + microcontrolador</p></td>
<td><p>ESP32 + Wi-Fi/BT</p></td>
<td><p>Medici&#243;n y transmisi&#243;n de datos</p></td>
</tr>
<tr>
<td><p>Comunicaci&#243;n</p></td>
<td><p>Protocolo de mensajer&#237;a</p></td>
<td><p>MQTT local sin TLS; TLS/ACL de producci&#243;n pendiente</p></td>
<td><p>Transmisi&#243;n segura sensor–nube</p></td>
</tr>
<tr>
<td><p>Backend</p></td>
<td><p>API REST</p></td>
<td><p>Node.js / Express</p></td>
<td><p>L&#243;gica de negocio y endpoints</p></td>
</tr>
<tr>
<td><p>Base de datos</p></td>
<td><p>Almacenamiento persistente</p></td>
<td><p>PostgreSQL; servicio gestionado considerado como alternativa en la propuesta original</p></td>
<td><p>Datos de usuarios, hogares, consumo</p></td>
</tr>
<tr>
<td><p>Nube / servicio IoT (alternativas de la propuesta original)</p></td>
<td><p>Conectividad dispositivos</p></td>
<td><p>AWS IoT Core o proveedor externo eran alternativas consideradas; no describen el despliegue actual</p></td>
<td><p>Gesti&#243;n de dispositivos IoT</p></td>
</tr>
<tr>
<td><p>Frontend m&#243;vil</p></td>
<td><p>Aplicaci&#243;n Android</p></td>
<td><p>React/Vite web; Expo/React Native con WebView para m&#243;vil (JavaScript)</p></td>
<td><p>Interfaz multiplataforma para usuarios</p></td>
</tr>
<tr>
<td><p>Frontend web</p></td>
<td><p>Panel de administraci&#243;n</p></td>
<td><p>HTML5 + CSS3 + JS</p></td>
<td><p>Gesti&#243;n desde navegador</p></td>
</tr>
<tr>
<td><p>Dise&#241;o UI/UX</p></td>
<td><p>Prototipado</p></td>
<td><p>Figma</p></td>
<td><p>Interfaces y flujos de usuario</p></td>
</tr>
<tr>
<td><p>Control versiones</p></td>
<td><p>Gesti&#243;n de c&#243;digo</p></td>
<td><p>Git / GitHub</p></td>
<td><p>Trabajo colaborativo del equipo</p></td>
</tr>
</table>


<strong>6.2 Requerimientos de Hardware para el Equipo de Desarrollo</strong>

<p>• Computadores con procesadores Ryzen 7 / Intel i7, mínimo 16 GB RAM y SSD 512 GB.</p>
<p>• Dispositivos móviles Android (versión 9 o superior) para pruebas de la aplicación.</p>
<p>• Sensores de caudal compatibles con Wi-Fi/Bluetooth para simulaciones IoT.</p>
<p>• Router Wi-Fi 2.4/5 GHz para pruebas de conectividad de dispositivos.</p>

<strong>6.3 Requerimientos Técnicos del Sistema (No Funcionales)</strong>

Según el SRS, los principales RNF que impactan el diseño técnico y económico son:


<table>
<tr>
<td><p><strong>Categor&#237;a</strong></p></td>
<td><p><strong>Requisito Clave</strong></p></td>
<td><p><strong>Criterio de Aceptaci&#243;n</strong></p></td>
</tr>
<tr>
<td><p>Rendimiento</p></td>
<td><p>Tiempo de inicio y respuesta</p></td>
<td><p>App inicia en &lt; 5 s; respuesta por solicitud &lt; 3 s</p></td>
</tr>
<tr>
<td><p>Escalabilidad</p></td>
<td><p>Soporte de usuarios concurrentes</p></td>
<td><p>≥ 100 usuarios simult&#225;neos sin degradaci&#243;n</p></td>
</tr>
<tr>
<td><p>Disponibilidad</p></td>
<td><p>Uptime del sistema</p></td>
<td><p>≥ meta propuesta no medida; recuperaci&#243;n &lt; 15 minutos</p></td>
</tr>
<tr>
<td><p>Seguridad</p></td>
<td><p>Cifrado y autenticaci&#243;n</p></td>
<td><p>HTTPS/TLS, AES-256, tokens JWT &#250;nicos</p></td>
</tr>
<tr>
<td><p>Compatibilidad</p></td>
<td><p>Plataformas soportadas</p></td>
<td><p>Android 9–14; Chrome, Edge, Firefox, Opera</p></td>
</tr>
<tr>
<td><p>Notificaciones</p></td>
<td><p>Tiempo real de alertas</p></td>
<td><p>Env&#237;o &lt; 3 s, tasa de entrega ≥ 98%</p></td>
</tr>
<tr>
<td><p>Cumplimiento</p></td>
<td><p>Marco legal colombiano</p></td>
<td><p>Ley 1581 de 2012 – Protecci&#243;n de datos personales</p></td>
</tr>
<tr>
<td><p>Portabilidad</p></td>
<td><p>Responsive y multiplataforma</p></td>
<td><p>Compatible en pantallas 5&quot; a 24&quot;</p></td>
</tr>
</table>


<strong>6.4 Infraestructura en la Nube</strong>

<table>
<tr>
<td><p><strong>Servicio</strong></p></td>
<td><p><strong>Funci&#243;n Principal</strong></p></td>
<td><p><strong>Costo Mensual (COP)</strong></p></td>
<td><p><strong>Costo 6 Meses (COP)</strong></p></td>
</tr>
<tr>
<td><p>Broker MQTT y servicio IoT en la nube: estimación original, no configuración vigente</p></td>
<td><p>Conectividad y monitoreo de sensores</p></td>
<td><p>$ 150.000</p></td>
<td><p>$ 900.000</p></td>
</tr>
<tr>
<td><p>AWS Lambda / Google Cloud Functions (alternativas de la estimación original)</p></td>
<td><p>Automatizaci&#243;n de eventos y alertas</p></td>
<td><p>$ 50.000</p></td>
<td><p>$ 300.000</p></td>
</tr>
<tr>
<td><p>Amazon RDS / Firestore</p></td>
<td><p>Base de datos gestionada en la nube</p></td>
<td><p>$ 50.000</p></td>
<td><p>$ 300.000</p></td>
</tr>
<tr>
<td><p>Amazon S3 / Cloud Storage</p></td>
<td><p>Almacenamiento de reportes y backups</p></td>
<td><p>$ 50.000</p></td>
<td><p>$ 300.000</p></td>
</tr>
<tr>
<td><p><strong>TOTAL</strong><strong> INFRAESTRUCTURA (6 meses)</strong></p></td>
<td><p>&nbsp;</p></td>
<td><p>&nbsp;</p></td>
<td><p><strong>$ 1.800.000</strong></p></td>
</tr>
</table>


<strong>7. EQUIPO DE TRABAJO Y RECURSOS HUMANOS</strong>


<strong>7.1 Equipo de Desarrollo</strong>

<table>
<tr>
<td><p><strong>Integrante</strong></p></td>
<td><p><strong>Rol en el Proyecto</strong></p></td>
<td><p><strong>Responsabilidades Principales</strong></p></td>
<td><p><strong>Duraci&#243;n</strong></p></td>
<td><p><strong>Salario/mes</strong></p></td>
<td><p><strong>Total (COP)</strong></p></td>
</tr>
<tr>
<td><p>Jos&#233; Alejandro Montealegre Rodr&#237;guez</p></td>
<td><p>L&#237;der / Base de Datos / QA</p></td>
<td><p>Planificaci&#243;n, gesti&#243;n BD, control de calidad, documentaci&#243;n t&#233;cnica</p></td>
<td><p>6 meses</p></td>
<td><p>$ 2.500.000</p></td>
<td><p>$ 15.000.000</p></td>
</tr>
<tr>
<td><p>Emerson Calet Molano Cardozo</p></td>
<td><p>Programador / Backend / IoT</p></td>
<td><p>Desarrollo de c&#243;digo, integraci&#243;n de sensores IoT, l&#243;gica de negocio</p></td>
<td><p>6 meses</p></td>
<td><p>$ 2.300.000</p></td>
<td><p>$ 13.800.000</p></td>
</tr>
<tr>
<td><p>Jos&#233; David Amaya Mosquera</p></td>
<td><p>Analista / Frontend / Documentaci&#243;n</p></td>
<td><p>An&#225;lisis de requerimientos, interfaces web/m&#243;vil, documentaci&#243;n del proyecto</p></td>
<td><p>6 meses</p></td>
<td><p>$ 2.300.000</p></td>
<td><p>$ 13.800.000</p></td>
</tr>
<tr>
<td><p><strong>TOTAL</strong><strong> RECURSOS HUMANOS (equipo)</strong></p></td>
<td><p>&nbsp;</p></td>
<td><p>&nbsp;</p></td>
<td><p>&nbsp;</p></td>
<td><p>&nbsp;</p></td>
<td><p><strong>$ 42.600.000</strong></p></td>
</tr>
</table>


<strong>7.2 Mano de Obra Técnica Complementaria</strong>

<table>
<tr>
<td><p><strong>Rol</strong></p></td>
<td><p><strong>Actividad</strong></p></td>
<td><p><strong>Horas Estimadas</strong></p></td>
<td><p><strong>Valor/Hora (COP)</strong></p></td>
<td><p><strong>Total (COP)</strong></p></td>
</tr>
<tr>
<td><p>Programador IoT</p></td>
<td><p>Firmware ESP32 y comunicaci&#243;n MQTT</p></td>
<td><p>60 h</p></td>
<td><p>$ 25.000</p></td>
<td><p>$ 1.500.000</p></td>
</tr>
<tr>
<td><p>Dise&#241;ador UI/UX</p></td>
<td><p>Prototipado en Figma y gu&#237;as de estilo</p></td>
<td><p>40 h</p></td>
<td><p>$ 20.000</p></td>
<td><p>$ 800.000</p></td>
</tr>
<tr>
<td><p>Tester / QA</p></td>
<td><p>Validaci&#243;n de software, pruebas funcionales y no funcionales</p></td>
<td><p>30 h</p></td>
<td><p>$ 18.000</p></td>
<td><p>$ 540.000</p></td>
</tr>
<tr>
<td><p><strong>SUBTOTAL MANO DE OBRA T&#201;CNICA</strong></p></td>
<td><p>&nbsp;</p></td>
<td><p>&nbsp;</p></td>
<td><p>&nbsp;</p></td>
<td><p><strong>$ 2.840.000</strong></p></td>
</tr>
</table>


<strong>8. PRESUPUESTO TÉCNICO Y ECONÓMICO</strong>


<strong>8.1 Hardware y Componentes </strong><strong>IoT</strong>

<table>
<tr>
<td><p><strong>&#205;tem</strong></p></td>
<td><p><strong>Descripci&#243;n</strong></p></td>
<td><p><strong>Cant</strong><strong>.</strong></p></td>
<td><p><strong>Costo </strong><strong>Unit</strong><strong>. (COP)</strong></p></td>
<td><p><strong>Costo Total (COP)</strong></p></td>
</tr>
<tr>
<td><p>Sensor de caudal</p></td>
<td><p>Medici&#243;n de flujo de agua (Wi-Fi/BT)</p></td>
<td><p>3</p></td>
<td><p>$ 25.000</p></td>
<td><p>$ 75.000</p></td>
</tr>
<tr>
<td><p>Microcontrolador ESP32</p></td>
<td><p>Procesamiento y conectividad IoT</p></td>
<td><p>3</p></td>
<td><p>$ 60.000</p></td>
<td><p>$ 180.000</p></td>
</tr>
<tr>
<td><p>V&#225;lvula solenoide 12V</p></td>
<td><p>Control remoto del flujo de agua</p></td>
<td><p>3</p></td>
<td><p>$ 30.000</p></td>
<td><p>$ 90.000</p></td>
</tr>
<tr>
<td><p>M&#243;dulo rel&#233; doble 5V</p></td>
<td><p>Activaci&#243;n de v&#225;lvulas y actuadores</p></td>
<td><p>3</p></td>
<td><p>$ 20.000</p></td>
<td><p>$ 60.000</p></td>
</tr>
<tr>
<td><p>Pantalla OLED 0.96&quot;</p></td>
<td><p>Visualizaci&#243;n local de datos del sensor</p></td>
<td><p>3</p></td>
<td><p>$ 35.000</p></td>
<td><p>$ 105.000</p></td>
</tr>
<tr>
<td><p>Fuente de poder 5V 2A</p></td>
<td><p>Alimentaci&#243;n de microcontroladores</p></td>
<td><p>3</p></td>
<td><p>$ 25.000</p></td>
<td><p>$ 75.000</p></td>
</tr>
<tr>
<td><p>Materiales varios</p></td>
<td><p>PVC, silicona, conectores, tornillos, cables</p></td>
<td><p>1</p></td>
<td><p>—</p></td>
<td><p>$ 190.000</p></td>
</tr>
<tr>
<td><p><strong>SUBTOTAL COMPONENTES </strong><strong>IoT</strong></p></td>
<td><p>&nbsp;</p></td>
<td><p>&nbsp;</p></td>
<td><p>&nbsp;</p></td>
<td><p><strong>$ 775.000</strong></p></td>
</tr>
</table>


<strong>8.2 Equipos de Trabajo de los Integrantes</strong>

<table>
<tr>
<td><p><strong>Integrante</strong></p></td>
<td><p><strong>Tipo</strong></p></td>
<td><p><strong>Especificaciones</strong></p></td>
<td><p><strong>Costo (COP)</strong></p></td>
</tr>
<tr>
<td><p>Emerson Calet Molano Cardozo</p></td>
<td><p>PC de escritorio</p></td>
<td><p>Ryzen 7 5700G / 32 GB RAM / SSD 1 TB / Monitor LG 24&quot;</p></td>
<td><p>$ 3.830.000</p></td>
</tr>
<tr>
<td><p>Emerson Calet Molano Cardozo</p></td>
<td><p>Port&#225;til</p></td>
<td><p>HP Pavilion Ryzen 7 7730U / 16 GB / SSD 512 GB</p></td>
<td><p>$ 3.500.000</p></td>
</tr>
<tr>
<td><p>Emerson Calet Molano Cardozo</p></td>
<td><p>Celular Android</p></td>
<td><p>Xiaomi Redmi Note 13 Pro+ / Android 14 / 8 GB / 256 GB</p></td>
<td><p>$ 2.100.000</p></td>
</tr>
<tr>
<td><p>Jos&#233; David Amaya Mosquera</p></td>
<td><p>PC de escritorio</p></td>
<td><p>Intel i7-12700F / 32 GB / GTX 1660S / SSD 1 TB / Samsung 24&quot;</p></td>
<td><p>$ 5.390.000</p></td>
</tr>
<tr>
<td><p>Jos&#233; David Amaya Mosquera</p></td>
<td><p>Port&#225;til</p></td>
<td><p>Dell Inspiron i7 1355U / 16 GB / SSD 512 GB</p></td>
<td><p>$ 3.700.000</p></td>
</tr>
<tr>
<td><p>Jos&#233; David Amaya Mosquera</p></td>
<td><p>Celular Android</p></td>
<td><p>Samsung Galaxy A35 / Android 14 / 8 GB / 256 GB</p></td>
<td><p>$ 1.950.000</p></td>
</tr>
<tr>
<td><p>Jos&#233; Alejandro Montealegre Rodr&#237;guez</p></td>
<td><p>PC de escritorio</p></td>
<td><p>Ryzen 5 5600 / 16 GB / RX 6600 / SSD 512 GB / LG 27&quot;</p></td>
<td><p>$ 4.420.000</p></td>
</tr>
<tr>
<td><p>Jos&#233; Alejandro Montealegre Rodr&#237;guez</p></td>
<td><p>Port&#225;til</p></td>
<td><p>Lenovo IdeaPad 5 Ryzen 7 7735HS / 16 GB / SSD 1 TB</p></td>
<td><p>$ 3.600.000</p></td>
</tr>
<tr>
<td><p>Jos&#233; Alejandro Montealegre Rodr&#237;guez</p></td>
<td><p>Celular Android</p></td>
<td><p>Motorola Edge 40 Neo / Android 14 / 8 GB / 256 GB</p></td>
<td><p>$ 1.800.000</p></td>
</tr>
<tr>
<td><p><strong>TOTAL</strong><strong> EQUIPOS DE DESARROLLO</strong></p></td>
<td><p>&nbsp;</p></td>
<td><p>&nbsp;</p></td>
<td><p><strong>$ 30.290.000</strong></p></td>
</tr>
</table>


<strong>8.3 Presupuesto Consolidado Global</strong>

<table>
<tr>
<td><p><strong>N&#176;</strong></p></td>
<td><p><strong>Categor&#237;a</strong></p></td>
<td><p><strong>Descripci&#243;n</strong></p></td>
<td><p><strong>Costo (COP)</strong></p></td>
<td><p><strong>% del Total</strong></p></td>
</tr>
<tr>
<td><p>1</p></td>
<td><p>Recursos humanos del equipo</p></td>
<td><p>Salarios de los 3 integrantes &#215; 6 meses</p></td>
<td><p>$ 42.600.000</p></td>
<td><p>53,0%</p></td>
</tr>
<tr>
<td><p>2</p></td>
<td><p>Equipos de desarrollo</p></td>
<td><p>PCs, port&#225;tiles y celulares de los integrantes</p></td>
<td><p>$ 30.290.000</p></td>
<td><p>37,7%</p></td>
</tr>
<tr>
<td><p>3</p></td>
<td><p>Mano de obra t&#233;cnica</p></td>
<td><p>Programador IoT, dise&#241;ador UX, tester QA</p></td>
<td><p>$ 2.840.000</p></td>
<td><p>3,5%</p></td>
</tr>
<tr>
<td><p>4</p></td>
<td><p>Infraestructura en la nube</p></td>
<td><p>Mosquitto/MQTT local; servicio cloud no verificado IoT Core no verificado, Lambda, RDS, S3 (6 meses)</p></td>
<td><p>$ 1.800.000</p></td>
<td><p>2,2%</p></td>
</tr>
<tr>
<td><p>5</p></td>
<td><p>Costos operativos</p></td>
<td><p>Energ&#237;a, internet, mantenimiento, imprevistos</p></td>
<td><p>$ 2.000.000</p></td>
<td><p>2,5%</p></td>
</tr>
<tr>
<td><p>6</p></td>
<td><p>Componentes IoT y materiales</p></td>
<td><p>Sensores, microcontroladores, v&#225;lvulas, PVC</p></td>
<td><p>$ 775.000</p></td>
<td><p>1,0%</p></td>
</tr>
<tr>
<td><p>&nbsp;</p></td>
<td><p><strong>TOTAL</strong><strong> GENERAL DEL PROYECTO</strong></p></td>
<td><p><strong>(incluye equipos de desarrollo)</strong></p></td>
<td><p><strong>$ 80.305.000*</strong></p></td>
<td><p><strong>100%</strong></p></td>
</tr>
</table>


<em>\* El total de $ 80.305.000 COP incluye todos los costos del proyecto, sin descontar los equipos de los integrantes que se usarán también para uso personal. Si se consolida el total con equipos: $ 110.595.000 COP.</em>


<strong>9. PLAN DE MANTENIMIENTO Y SOPORTE</strong>


El plan de mantenimiento de Hidro Smart cubre un período de 6 meses posteriores a la entrega del sistema, bajo tres modalidades:


<table>
<tr>
<td><p><strong>Tipo</strong></p></td>
<td><p><strong>Actividades</strong></p></td>
<td><p><strong>Frecuencia</strong></p></td>
<td><p><strong>Responsable</strong></p></td>
</tr>
<tr>
<td><p>Preventivo</p></td>
<td><p>Revisi&#243;n de firmware, calibraci&#243;n de sensores, actualizaci&#243;n de dependencias, backup de base de datos</p></td>
<td><p>Mensual</p></td>
<td><p>Programador IoT / L&#237;der del proyecto</p></td>
</tr>
<tr>
<td><p>Correctivo</p></td>
<td><p>Sustituci&#243;n de m&#243;dulos defectuosos, correcci&#243;n de bugs, ajuste de par&#225;metros de caudal</p></td>
<td><p>A demanda (&lt; 2 h respuesta cr&#237;tica)</p></td>
<td><p>Programador IoT / Backend</p></td>
</tr>
<tr>
<td><p>Evolutivo</p></td>
<td><p>Nuevas funcionalidades, optimizaci&#243;n de rendimiento, integraci&#243;n con nuevas plataformas</p></td>
<td><p>Trimestral</p></td>
<td><p>Equipo completo</p></td>
</tr>
<tr>
<td><p>Seguridad</p></td>
<td><p>Renovaci&#243;n de certificados SSL/TLS, revisi&#243;n de auditor&#237;as, actualizaci&#243;n de tokens</p></td>
<td><p>Semestral</p></td>
<td><p>L&#237;der / Backend</p></td>
</tr>
</table>


El sistema cuenta con mecanismos automáticos de recuperación ante fallos (RNF4.4): en caso de caída, el tiempo de recuperación no debe superar los 5 minutos y no se perderá información registrada antes del fallo.


<strong>10. IMPACTO AMBIENTAL Y SOSTENIBILIDAD</strong>


Hidro Smart contribuye activamente al desarrollo sostenible mediante los siguientes impactos medibles:


<table>
<tr>
<td><p><strong>Indicador de Impacto</strong></p></td>
<td><p><strong>Valor Estimado</strong></p></td>
<td><p><strong>Fundamento</strong></p></td>
</tr>
<tr>
<td><p>Reducci&#243;n del consumo de agua por hogar</p></td>
<td><p>15% – 25% anual</p></td>
<td><p>Uso de alertas, recomendaciones y modelo predictivo</p></td>
</tr>
<tr>
<td><p>Hogares colombianos potencialmente beneficiados</p></td>
<td><p>Millones (solo el 33% ahorra agua actualmente)</p></td>
<td><p>DANE 2024</p></td>
</tr>
<tr>
<td><p>Reducci&#243;n del desperdicio h&#237;drico nacional</p></td>
<td><p>Contribuci&#243;n a reducir el 48% de p&#233;rdidas</p></td>
<td><p>Universidad de los Andes 2024</p></td>
</tr>
<tr>
<td><p>Huella de carbono del sistema</p></td>
<td><p>M&#237;nima – sensores de bajo consumo, app ligera</p></td>
<td><p>Dise&#241;o eficiente (RNF8.1: CPU en background &lt; 15%)</p></td>
</tr>
<tr>
<td><p>Cumplimiento ODS</p></td>
<td><p>ODS 6 (Agua limpia), ODS 9 (Innovaci&#243;n), ODS 13 (Clima)</p></td>
<td><p>Objetivos de Desarrollo Sostenible ONU</p></td>
</tr>
</table>


A futuro, el sistema puede ampliarse con integración de paneles solares para alimentar los dispositivos IoT, logrando autonomía energética parcial y reduciendo la huella de carbono del proyecto. También se prevé la integración futura con redes externas de servicios públicos y plataformas de gestión municipal del agua.


<strong>11. CRONOGRAMA DE EJECUCIÓN Y PAGOS</strong>


<table>
<tr>
<td><p><strong>Fase</strong></p></td>
<td><p><strong>Descripci&#243;n</strong></p></td>
<td><p><strong>Duraci&#243;n</strong></p></td>
<td><p><strong>% de Pago</strong></p></td>
<td><p><strong>Monto Aprox. (COP)</strong></p></td>
</tr>
<tr>
<td><p>1</p></td>
<td><p>An&#225;lisis de requerimientos, SRS y planificaci&#243;n del proyecto</p></td>
<td><p>2 semanas</p></td>
<td><p>15%</p></td>
<td><p>$ 12.045.750</p></td>
</tr>
<tr>
<td><p>2</p></td>
<td><p>Dise&#241;o t&#233;cnico, arquitectura del sistema y prototipado UI/UX (Figma)</p></td>
<td><p>2 semanas</p></td>
<td><p>20%</p></td>
<td><p>$ 16.061.000</p></td>
</tr>
<tr>
<td><p>3</p></td>
<td><p>Desarrollo frontend m&#243;vil/web: m&#243;dulos RF1, RF2 y RF3</p></td>
<td><p>4 semanas</p></td>
<td><p>20%</p></td>
<td><p>$ 16.061.000</p></td>
</tr>
<tr>
<td><p>4</p></td>
<td><p>Desarrollo backend, IoT e integraci&#243;n nube: m&#243;dulos RF4 y RF5</p></td>
<td><p>4 semanas</p></td>
<td><p>25%</p></td>
<td><p>$ 20.076.250</p></td>
</tr>
<tr>
<td><p>5</p></td>
<td><p>Pruebas de sistema, validaci&#243;n funcional/no funcional y correcciones QA</p></td>
<td><p>2 semanas</p></td>
<td><p>10%</p></td>
<td><p>$ 8.030.500</p></td>
</tr>
<tr>
<td><p>6</p></td>
<td><p>Implementaci&#243;n piloto, entrega final y documentaci&#243;n t&#233;cnica</p></td>
<td><p>2 semanas</p></td>
<td><p>10%</p></td>
<td><p>$ 8.030.500</p></td>
</tr>
<tr>
<td><p><strong>TOTAL</strong></p></td>
<td><p>&nbsp;</p></td>
<td><p><strong>16 semanas (6 meses)</strong></p></td>
<td><p><strong>100%</strong></p></td>
<td><p><strong>$ 80.305.000</strong></p></td>
</tr>
</table>


<strong>12. ANÁLISIS DE VIABILIDAD ECONÓMICA</strong>


<strong>12.1 Viabilidad Técnica</strong>

La propuesta original seleccionó tecnologías de uso extendido. La implementación documentada ahora utiliza React/Vite, Expo/React Native, Node.js/Express, PostgreSQL/Liquibase y ESP32; su configuración actual se resume en el anexo de este documento. La disponibilidad, escalabilidad, seguridad y costos del ambiente dependen de la configuración y pruebas del despliegue, y no se deducen solo de la elección tecnológica.


<strong>12.2 Viabilidad Económica</strong>

El análisis costo-beneficio original proyectó ahorros mensuales de $ 50.000–$ 120.000 COP por hogar bajo el supuesto de una reducción del consumo. Esos valores no están validados con mediciones de uso ni tarifas actuales y se conservan solo como hipótesis académica; no son resultados observados ni un pronóstico garantizado.


<table>
<tr>
<td><p><strong>Escenario</strong></p></td>
<td><p><strong>Inversi&#243;n</strong></p></td>
<td><p><strong>Ahorro mensual/hogar</strong></p></td>
<td><p><strong>Recuperaci&#243;n estimada</strong></p></td>
</tr>
<tr>
<td><p>Conservador (15% ahorro)</p></td>
<td><p>$ 80.305.000 COP</p></td>
<td><p>$ 50.000 COP</p></td>
<td><p>N/A (proyecto educativo/piloto)</p></td>
</tr>
<tr>
<td><p>Esperado (20% ahorro)</p></td>
<td><p>$ 80.305.000 COP</p></td>
<td><p>$ 80.000 COP</p></td>
<td><p>N/A (proyecto educativo/piloto)</p></td>
</tr>
<tr>
<td><p>Optimista (25% ahorro)</p></td>
<td><p>$ 80.305.000 COP</p></td>
<td><p>$ 120.000 COP</p></td>
<td><p>N/A (proyecto educativo/piloto)</p></td>
</tr>
</table>


<strong>12.3 Viabilidad Legal</strong>

El sistema cumple con la Ley 1581 de 2012 de Protección de Datos Personales de Colombia (RNF8.2). Todo tratamiento de datos de usuarios requiere consentimiento explícito, y las políticas de privacidad estarán actualizadas y accesibles dentro de la plataforma.


<strong>13. CONCLUSIONES</strong>


El documento de propuesta 2025 plantea la aplicación de IoT al monitoreo del agua en hogares colombianos. No demuestra por sí solo factibilidad económica ni cumplimiento completo de requisitos. La implementación y aceptación de cada requisito deben sustentarse con el código y la evidencia de pruebas de la versión final.


La cifra de $ 80.305.000 COP y el ahorro hídrico del 15 % al 25 % son estimaciones de la fuente académica, no un presupuesto auditado ni un ahorro medido. La vida útil, el rendimiento y la escalabilidad requieren pruebas y datos que no se presentan en esta propuesta.


El equipo de desarrollo, conformado por tres aprendices del SENA en Programación de Software, cuenta con la división de roles adecuada para ejecutar el proyecto dentro del plazo y presupuesto estimado: José Alejandro Montealegre (Base de Datos / QA), Emerson Calet Molano (Backend / IoT) y José David Amaya (Análisis / Frontend).


En conclusión, Hidro Smart se posiciona como una propuesta tecnológica, ecológica y socialmente responsable, con impacto real en la conservación del agua y alineada con los Objetivos de Desarrollo Sostenible ODS 6, ODS 9 y ODS 13 de la ONU.


<strong>14. REFERENCIAS</strong>


<p>• Personería de Bogotá (2024). Informe sobre pérdidas de agua potable en la capital colombiana.</p>
<p>• Universidad de los Andes (2024). Estudio sobre desperdicio hídrico en Colombia.</p>
<p>• DANE (2024). Encuesta Nacional de Prácticas de Ahorro Hídrico en Colombia.</p>
<p>• IEEE Standard 830-1998. Recommended Practice for Software Requirements Specifications. IEEE.</p>
<p>• Ley 1581 de 2012. Régimen General de Protección de Datos Personales en Colombia. Congreso de la República.</p>
<p>• AWS IoT Core. Alternativa de la propuesta original; no es el broker que se documenta para el despliegue actual. https://aws.amazon.com/es/iot-core</p>
<p>• Firebase. Alternativa mencionada en el documento fuente; no se declara como servicio activo de la línea base actual. https://firebase.google.com</p>
<p>• React/Vite web; Expo/React Native con WebView para móvil – Framework de desarrollo móvil multiplataforma (Meta). https://reactnative.dev</p>
<p>• Node.js – Entorno de ejecución JavaScript del servidor. https://nodejs.org</p>
<p>• PostgreSQL – Sistema de gestión de bases de datos relacional. https://www.postgresql.org</p>
<p>• Figma Inc. – Herramienta de diseño colaborativo UI/UX. https://figma.com</p>
Control de actualización

<strong>Fecha de revisión documental: 2026-11-04. Estado: propuesta histórica con reconciliación técnica; pendiente de revisión contra la versión final.</strong>

Fuentes: informe técnico/económico académico, PT_HS como monorepo canónico y repositorios separados como referencias de componentes. Las estimaciones originales se preservan como antecedentes.

Se mantiene la propuesta técnica/económica original, incluidos sus capítulos, tablas y cronograma. La actualización evita presentar nube, seguridad, SLA, ahorro o costos como hechos comprobados cuando no existe evidencia en el repositorio.

<p>• Organización de las Naciones Unidas – Objetivos de Desarrollo Sostenible. https://sdgs.un.org</p>

Anexo de actualización 2026: propuesta técnica vigente

Las secciones, cronogramas y tablas económicas del documento original se conservan como propuesta y antecedente. Los valores económicos no fueron recalculados ni auditados; no deben interpretarse como costos contratados o de producción.

Stack observado en los repositorios

| Capa | Tecnología documentada | Límite de la afirmación |
|---|---|---|
| Web | React, Vite y TypeScript | El build y la disponibilidad deben asociarse al commit final. |
| Móvil | Expo y React Native, SDK 57 | BLE requiere compilación nativa; esta propuesta no acredita una prueba integral en teléfono. |
| Backend | Node.js y Express | La API debe probarse con el mismo tag que se entregue. |
| Persistencia | PostgreSQL y Liquibase | Las cifras de tablas y changesets del informe original son históricas; volver a obtenerlas del tag final. |
| MQTT | Flespi con TLS para integración externa; Mosquitto para desarrollo local | Verificar conectividad, ACL y credenciales por dispositivo en el despliegue final. |
| Correo | Brevo | La configuración en código no prueba por sí sola la entrega de cada tipo de correo. |
| Firmware | ESP32 con framework Arduino/C++ | Repetir la prueba física de aprovisionamiento, telemetría y modo de medición sobre el firmware entregado. |
| Proveedores de despliegue | Cloudflare Pages, Render y Neon aparecen en la documentación operativa | Comprobar disponibilidad, configuración y variables del ambiente final; no incluir secretos en los documentos. |

AWS IoT Core, Firebase y Redis aparecen en partes de la propuesta histórica. No se consideran servicios activos de la línea base actual sin evidencia específica.


Clasificación de afirmaciones económicas

Presupuesto global: conservar como estimación del documento original, sin presentarlo como gasto comprobado.

Ahorro porcentual, SLA del 99 %, concurrencia y tiempos de respuesta: metas o hipótesis sin medición en el corte.

Precios de nube y proveedores: no verificables desde el repositorio; requieren cotización actual antes de una propuesta formal.

Recursos y roles del equipo: conservar como información del documento de proyecto; no se infieren responsables operativos nuevos.
