/**
 * ============================================================
 *  GOOGLE APPS SCRIPT — Backend para Credencial Digital
 *  Sindicato de la Carne, Colón
 * ============================================================
 *
 *  Valida DNI + Nombre y Apellido contra el Google Sheet
 *  y devuelve los datos del afiliado en formato JSON.
 *
 *  INSTRUCCIONES DE USO:
 *  1. Pegá todo este código en el editor de Apps Script.
 *  2. Guardá y desplegá como "Aplicación web".
 *  3. Copiá la URL generada y pegala en AppConfig.loginApiUrl.
 * ============================================================
 */

// ── Nombre exacto de la hoja dentro del Spreadsheet ──────────
const SHEET_NAME = 'Afiliados';

// ── Nombres exactos de las columnas del encabezado ───────────
const COL_NOMBRE   = 'NOMBRE Y APELLIDO';
const COL_DNI      = 'DNI';
const COL_AFILIADO = 'NRO AFILIADO';
const COL_ESTAB    = 'ESTABLECIMIENTO';
const COL_VTO      = 'Vto';

/**
 * Maneja solicitudes GET desde la app Flutter.
 *
 * Parámetros de la URL:
 *   ?dni=30123456&nombre=JUAN+PEREZ
 *
 * Respuestas:
 *   { "success": true,  "dni": "...", "nombre": "...", "nroAfiliado": "...", "establecimiento": "...", "vto": "DD/MM/YYYY" }
 *   { "success": false, "message": "..." }
 */
function doGet(e) {
  const params = e.parameter;
  const dniParam    = (params.dni    || '').trim().toUpperCase();
  const nombreParam = (params.nombre || '').trim().toUpperCase();

  // Validar que los parámetros lleguen
  if (!dniParam || !nombreParam) {
    return buildResponse({ success: false, message: 'Parámetros faltantes: dni y nombre son obligatorios.' });
  }

  try {
    const result = buscarAfiliado(dniParam, nombreParam);
    return buildResponse(result);
  } catch (err) {
    return buildResponse({ success: false, message: 'Error interno: ' + err.message });
  }
}

/**
 * Busca el afiliado en el Google Sheet por DNI y Nombre.
 *
 * La comparación ignora mayúsculas/minúsculas y espacios extra.
 */
function buscarAfiliado(dni, nombre) {
  const ss    = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName(SHEET_NAME);

  if (!sheet) {
    return { success: false, message: 'La hoja "' + SHEET_NAME + '" no existe en el Spreadsheet.' };
  }

  const data    = sheet.getDataRange().getValues();
  const headers = data[0].map(h => String(h).trim()); // Primera fila = encabezados

  // Obtener índices de columnas por nombre exacto
  const idxNombre   = headers.indexOf(COL_NOMBRE);
  const idxDni      = headers.indexOf(COL_DNI);
  const idxAfiliado = headers.indexOf(COL_AFILIADO);
  const idxEstab    = headers.indexOf(COL_ESTAB);
  const idxVto      = headers.indexOf(COL_VTO);

  if (idxDni === -1 || idxNombre === -1) {
    return { success: false, message: 'Columnas "DNI" o "NOMBRE Y APELLIDO" no encontradas en la hoja.' };
  }

  // Recorrer filas buscando coincidencia exacta (case-insensitive, sin espacios extra)
  for (let i = 1; i < data.length; i++) {
    const rowDni    = String(data[i][idxDni]).trim().toUpperCase();
    const rowNombre = String(data[i][idxNombre]).trim().toUpperCase();

    if (rowDni === dni && rowNombre === nombre) {
      // Formatear la fecha de vencimiento
      let vtoStr = '';
      if (idxVto !== -1 && data[i][idxVto]) {
        const vtoCell = data[i][idxVto];
        if (vtoCell instanceof Date) {
          // Google Sheets puede devolver una fecha como objeto Date
          const d = vtoCell;
          vtoStr = `${pad(d.getDate())}/${pad(d.getMonth() + 1)}/${d.getFullYear()}`;
        } else {
          vtoStr = String(vtoCell).trim();
        }
      }

      return {
        success: true,
        dni:            rowDni,
        nombre:         String(data[i][idxNombre]).trim(),
        nroAfiliado:    idxAfiliado !== -1 ? String(data[i][idxAfiliado]).trim() : '',
        establecimiento: idxEstab  !== -1 ? String(data[i][idxEstab]).trim()    : '',
        vto:            vtoStr,
      };
    }
  }

  return { success: false, message: 'DNI o Nombre y Apellido incorrectos. Por favor, verifique los datos.' };
}

/** Agrega cero a la izquierda para día/mes */
function pad(n) {
  return String(n).padStart(2, '0');
}

/**
 * Construye la respuesta HTTP con headers CORS para Flutter.
 */
function buildResponse(obj) {
  return ContentService
    .createTextOutput(JSON.stringify(obj))
    .setMimeType(ContentService.MimeType.JSON);
}
