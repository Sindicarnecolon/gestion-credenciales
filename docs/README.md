# Guía de Publicación en GitHub Pages

Para que la credencial digital de tu aplicación funcione de forma remota, debes hospedar la carpeta `docs` en GitHub Pages. Sigue estos sencillos pasos:

---

## Paso 1: Inicializar un Repositorio Git local

Si no has inicializado Git en la carpeta del proyecto, ejecuta los siguientes comandos en tu terminal de PowerShell en la raíz del proyecto (`Gestion_de_credenciales_Andorid_IOS`):

```powershell
# Inicializar repositorio git
git init

# Agregar todos los archivos al commit inicial
git add .

# Hacer el primer commit
git commit -m "Inicialización del proyecto y archivos de credencial para GitHub Pages"
```

---

## Paso 2: Crear el repositorio en tu cuenta de GitHub

1. Entra a [github.com](https://github.com) e inicia sesión con tu cuenta.
2. Haz clic en el botón **New** (Nuevo repositorio).
3. Nómbralo, por ejemplo, `gestion-credenciales` (puedes elegir el nombre que prefieras).
4. Elige si quieres que sea **Público** (necesario para GitHub Pages gratuito) o **Privado** (requiere GitHub Pro para usar Pages).
5. **No** selecciones añadir README, .gitignore o licencia, ya que el proyecto ya los tiene.
6. Haz clic en **Create repository** (Crear repositorio).

---

## Paso 3: Vincular y subir tu proyecto a GitHub

En la página de tu nuevo repositorio en GitHub, copia los comandos que se muestran bajo la sección "…or push an existing repository from the command line" y ejecútalos en la terminal del proyecto. Se verán similares a estos:

```powershell
# Cambiar la rama por defecto a main
git branch -M main

# Vincular tu repositorio local con el de GitHub (reemplaza con tu usuario y repo)
git remote add origin https://github.com/TU_USUARIO/TU_REPOSITORIO.git

# Subir los cambios a GitHub
git push -u origin main
```

---

## Paso 4: Activar GitHub Pages desde la carpeta `docs`

1. Entra a la página de tu repositorio en **GitHub**.
2. Dirígete a la pestaña **Settings** (Configuración) en el menú superior del repositorio.
3. En el menú de la izquierda, haz clic en **Pages** (dentro de la sección *Code and automation*).
4. En la sección **Build and deployment**:
   - **Source**: Asegúrate de que esté seleccionado **Deploy from a branch**.
   - **Branch**: Selecciona la rama **`main`** en el primer desplegable.
   - En el segundo desplegable (que dice `/ (root)` por defecto), cámbialo a **`/docs`**.
5. Haz clic en **Save** (Guardar).

---

## Paso 5: Obtener y configurar tu URL en Flutter

1. Espera entre 1 y 2 minutos. Refresca la página de Settings -> Pages en tu navegador.
2. En la parte superior verás un banner que dice:
   > Your site is live at `https://TU_USUARIO.github.io/TU_REPOSITORIO/`
3. Copia esa URL exacta.
4. Abre tu archivo `lib/config/app_config.dart` en Flutter y edita la constante:

```dart
static const String webviewCredentialUrl = 'https://TU_USUARIO.github.io/TU_REPOSITORIO/';
```

¡Eso es todo! La app cargará automáticamente la credencial con todos los datos dinámicos inyectados de forma segura e interactiva.
