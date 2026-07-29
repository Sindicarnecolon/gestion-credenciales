# Especificación del Proyecto – Aplicación de Credencial Digital de Afiliados

## Objetivo

Desarrollar una aplicación profesional utilizando Flutter, compatible con Android e iOS desde una única base de código.

La aplicación debe actuar como un **contenedor nativo (Native Shell)** para una aplicación web ya existente, la cual será integrada posteriormente mediante WebView.

La primera etapa del desarrollo consiste únicamente en construir una arquitectura sólida, escalable y profesional, dejando preparada toda la infraestructura para incorporar posteriormente la aplicación web sin necesidad de modificar la arquitectura.

---

# Directrices Generales

## Prioridad absoluta

Construir primero una base sólida antes que funcionalidades complejas.

La aplicación debe quedar preparada para crecer sin necesidad de reestructurar el proyecto.

---

## Optimización del desarrollo

Durante todo el desarrollo:

- Priorizar el uso eficiente de los tokens.
- Evitar generar código redundante.
- Evitar reescribir archivos completos cuando únicamente sea necesario modificar una pequeña sección.
- Reutilizar componentes existentes siempre que sea posible.
- Mantener respuestas concisas y enfocadas.
- No generar explicaciones innecesarias salvo que sean requeridas.

### Muy importante

Priorizar siempre:

**Una tarea completamente terminada**

por encima de

**Varias tareas iniciadas sin finalizar.**

No avanzar a la siguiente funcionalidad hasta dejar completamente terminada la actual.

---

# Arquitectura

La aplicación debe utilizar una arquitectura limpia, modular y fácilmente mantenible.

Organizar el proyecto por Features.

Separar claramente responsabilidades.

Ejemplo:

```
lib/

core/
shared/
config/
theme/
routes/
services/
repositories/
providers/
widgets/

features/

login/

home/

credential/

group_family/

news/

settings/
```

No crear archivos gigantes.

Mantener cada archivo con una única responsabilidad.

---

# Tecnologías

Utilizar únicamente paquetes oficiales o ampliamente mantenidos.

Arquitectura basada en:

- Material 3
- Riverpod
- GoRouter
- Flutter Secure Storage
- webview_flutter
- flutter_windowmanager (Android)

No agregar dependencias innecesarias.

---

# Configuración centralizada

Toda la configuración de la aplicación deberá encontrarse en un único archivo.

Ejemplo:

```
lib/config/app_config.dart
```

Toda configuración futura deberá obtenerse desde ese archivo.

Ejemplo:

```dart
WEBVIEW_CREDENTIAL_URL

WEBVIEW_GROUP_URL

LOGIN_API_URL

NEWS_API_URL

MARQUEE_TEXT

APP_NAME

COMPANY_NAME

SUPPORT_EMAIL

SUPPORT_PHONE
```

En el futuro solamente deberá modificarse este archivo para cambiar URLs, textos o configuraciones generales.

No distribuir constantes por distintos archivos.

---

# Referencias visuales

Las imágenes proporcionadas son únicamente una referencia visual.

No deben copiarse exactamente.

Utilizar solamente como inspiración para respetar:

- distribución general
- jerarquía visual
- posición de elementos
- tamaño relativo
- estilo limpio y moderno

La aplicación debe tener identidad propia.

---

# Pantalla Login

Inspirada en la estructura visual de la referencia.

Debe contener:

- Logo superior
- Mensaje de bienvenida
- Campo DNI
- Campo Número de Afiliado
- Botón Ingresar

No utilizar usuario y contraseña.

Toda la autenticación debe quedar preparada para conectarse posteriormente con un backend desarrollado mediante:

Google Apps Script + Google Sheets.

No implementar todavía dicho backend.

Crear únicamente la capa de autenticación desacoplada.

Guardar la sesión utilizando Flutter Secure Storage.

---

# Pantalla Home

Luego del Login mostrar una pantalla simple con acceso a:

- Credencial
- Grupo Familiar
- Novedades
- Configuración
- Cerrar sesión

La navegación debe ser completamente nativa.

---

# Pantalla Credencial

Esta pantalla utilizará una WebView.

No cargar todavía ninguna página.

La URL deberá obtenerse desde:

```
app_config.dart
```

Ejemplo:

```dart
WEBVIEW_CREDENTIAL_URL
```

Si la URL está vacía mostrar:

> La credencial aún no fue configurada.

Toda la WebView debe depender únicamente de esa configuración.

---

# Marquesina

Sobre la WebView deberá existir una barra fija.

Debe desplazarse continuamente de derecha a izquierda.

El texto debe obtenerse desde:

```
MARQUEE_TEXT
```

No utilizar paquetes pesados.

Implementar la animación con Flutter.

---

# Seguridad

Preparar la aplicación para:

- bloquear capturas de pantalla
- impedir screenshots
- ocultar contenido cuando la aplicación pase a segundo plano

Android:

Implementación completa.

iOS:

Dejar preparada la estructura indicando claramente dónde deberá agregarse la implementación nativa posteriormente.

---

# Control de vencimiento

Crear un servicio independiente.

Inicialmente utilizar una fecha local.

Si la credencial se encuentra vencida:

- impedir el acceso a la WebView
- mostrar una pantalla indicando:

> Su credencial se encuentra vencida.

Agregar un botón:

> Contactar Administración

Toda esta lógica deberá poder reemplazarse posteriormente por una consulta a API sin modificar la arquitectura.

---

# Grupo Familiar

Tomar como referencia únicamente la estructura visual del formulario mostrado en las imágenes.

No implementar todavía el formulario.

Esta pantalla también utilizará una WebView.

La URL deberá obtenerse desde:

```
WEBVIEW_GROUP_URL
```

Si la URL está vacía mostrar:

> Formulario aún no configurado.

---

# Novedades

Crear una pantalla sencilla preparada para consumir posteriormente una API.

Mientras tanto utilizar datos simulados.

Cada publicación deberá contener:

- título
- fecha
- descripción
- imagen opcional

Toda la lógica deberá quedar desacoplada.

---

# Configuración

Crear una pantalla simple preparada para futuras opciones.

No agregar funcionalidades que aún no fueron solicitadas.

---

# Diseño

Utilizar Material 3.

Características deseadas:

- moderno
- minimalista
- profesional
- responsive
- compatible con teléfonos y tablets
- modo claro
- preparado para modo oscuro
- animaciones suaves
- espaciados consistentes
- componentes reutilizables

---

# Calidad del código

Mantener un código limpio.

Evitar duplicación.

Separar correctamente:

- Models
- Services
- Providers
- Repositories
- Widgets
- Views
- Routes
- Theme
- Config

Documentar únicamente donde aporte valor.

---

# Restricciones

No implementar funcionalidades que no fueron solicitadas.

No crear lógica temporal difícil de reemplazar.

No modificar la arquitectura una vez definida.

Toda nueva funcionalidad deberá integrarse respetando la estructura existente.

---

# Resultado esperado

Al finalizar esta primera etapa deberá existir una aplicación completamente funcional como contenedor nativo, con:

- Login preparado para Google Apps Script + Google Sheets.
- Navegación nativa.
- Seguridad preparada.
- Control de vencimiento.
- WebView preparada para la credencial.
- WebView preparada para Grupo Familiar.
- Pantalla de Novedades preparada.
- Configuración centralizada mediante `app_config.dart`.
- Arquitectura profesional lista para incorporar posteriormente las páginas web reales simplemente modificando la configuración centralizada, sin necesidad de realizar cambios estructurales.