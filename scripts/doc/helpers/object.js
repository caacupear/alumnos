const sf = require("./connect");
const prompts = require("prompts");
const templateEngine = require("./template")("dictionary", "md");
const DICTIONARY_FOLDER = process.cwd() + "/docs/diccionarios/objects";
const WORKING_FOLDER = process.env.INIT_CWD || ".";
const DEFAULT_FILENAME = ".object.json";
const DEFAULT_INTRO = "intro";
const fs = require("fs");

async function getObjects(objetos) {
  try {
    await sf.connect();
    const objects = await sf.customObjects(objetos);

    return objects;
  } catch (e) {
    console.error(e);
  }
}

async function prompt(config) {
  if (config.items.length === 0 && !("r" in config.opciones)) {
    const response = await prompts({
      type: "list",
      name: "objects",
      separator: ",",
      initial: config.argumentos,
      message: 'Ingrese Api Name usando "," si son varios'
    });
    config.items = response.objects;
  }

  if (config.items.length > 1 && !("m" in config.opciones)) {
    const response = await prompts({
      type: "text",
      name: "modulo",
      initial: "intro",
      message: "Ingrese nombre archivo Markdown que seria Modulo de los objetos"
    });
    config.index = response.index;
  }
}
function descriptionFormula(a) {
  return this.description?.replaceAll(/[\n\r]/g, "<br/>");
}

function isManaged() {
  return this.fullName.split("__").length == 3;
}

function isMetadataFormula() {
  return this.fullName?.endsWith("__mdt") || this.customSettingsType;
}

function attributesFormula() {
  const attributes = [];
  // Object Attributes
  if (this.enableHistory === "true") {
    attributes.push(`![Track History](/img/tracker_60.png)`);
  }

  // "enableActivities": "true",
  // "enableBulkApi": "true",
  // "enableChangeDataCapture": "false",
  // "enableFeeds": "false",
  // "enableHistory": "true",
  // "enableReports": "true",
  // "enableSearch": "false",
  // "enableSharing": "true",
  // "enableStreamingApi": "true",
  // "externalSharingModel": "Private",

  // Field Attributes
  if (this.required === "true") {
    attributes.push(`![Required](/img/lock_60.png)`);
  }

  if (this.trackHistory === "true") {
    attributes.push(`![Track History](/img/tracker_60.png)`);
  }
  // if ( this.inlineHelpText ) {
  //     attributes.push( `![${this.inlineHelpText}](/img/help_60.png)` );
  // }
  if (this.externalId === "true") {
    attributes.push(`![External Id](/img/database_60.png)`);
  }
  if (this.encrypted === "true") {
    attributes.push(`![Encripted](/img/password_60.png)`);
  }
  return attributes.join(" ");
}
function typeFormula() {
  if (this.formula) {
    return `Formula(${this.type})`;
  }
  if (this.type === "Lookup") {
    return `[Lookup a ${this.referenceTo}](/diccionarios/objects/${this.referenceTo})`;
  }

  if (this.length || this.precision) {
    const longitud =
      (this.length || this.precision) +
      (this.scale && this.scale > 0 ? "." + this.scale : "");
    return `${this.type}(${longitud})`;
  }
  return this.type;
}

function help() {
  console.log(
    "Este comando se conecta a la metadata de los objetos de Salesforce (fuentes) y en base a los templates genera:"
  );
  console.log(
    "1. Por cada objeto usa el template object.md para crear un diccionario de datos del objeto en la carpeta " +
      DICTIONARY_FOLDER
  );
  console.log(
    "2. Crea un indice en la working folder usando el template objects.md"
  );
  console.log(
    "\nPuede llamarse para un objeto o varios, de la siguiente forma:"
  );
  console.log("npm run doc object Account");
  console.log("npm run doc object Account Case Contact --=index.md");
}

function sortByLabel(objA, objB) {
  return objA.label > objB.label ? 1 : objA.label < objB.label ? -1 : 0;
}

function getContextCache(fileName) {
  const fullName =
    fileName !== undefined
      ? WORKING_FOLDER + "/" + fileName
      : WORKING_FOLDER + "/" + DEFAULT_FILENAME;
  if (!fs.existsSync(fullName)) {
    throw new Error(
      `No existe el archivo ${fullName}. Debe ser un json generado por el flag -o`
    );
  }
  const content = fs.readFileSync(fullName);
  try {
    return JSON.parse(content).objects;
  } catch {
    throw new Error(
      "Archivo invalido: el  ${fileName} debe ser un json generado por el flag -o"
    );
  }
}

async function getContext(items, opciones) {
  let contexts;

  // flag -i lee del archivo cache
  if (opciones && "i" in opciones) {
    const allObjects = getContextCache(opciones.i);
    contexts = allObjects.filter((object) => items.includes(object.fullName));
  } else if (opciones && "r" in opciones) {
    // flag -r lee del archivo cache pero vuelve a buscar la metadata
    contexts = getContextCache(opciones.r);
    const itemsEnCache = contexts.map((object) => object.fullName);
    contexts = await getObjects(itemsEnCache);
  } else {
    // Sino buscar la metadata segun los items
    contexts = await getObjects(items);
  }

  if (contexts && !Array.isArray(contexts)) {
    contexts = [contexts];
  }
  return contexts;
}

async function execute({ items, opciones }) {
  // Busca la metadata
  const contexts = await getContext(items, opciones);

  if (!contexts || contexts.length === 0) {
    return;
  }
  // Arma el diccionario de cada Objeto
  templateEngine.read("object");
  for (const context of contexts) {
    templateEngine.render(context, {
      helpers: { isManaged, descriptionFormula, typeFormula, attributesFormula }
    });
    templateEngine.save(context.fullName, DICTIONARY_FOLDER);
  }
  // Arma el documento indice del grupo de objetos
  contexts.sort(sortByLabel);
  templateEngine.read("objects");
  const objectContext = { objects: contexts };

  if ("o" in opciones) {
    const fileName = opciones.o ? opciones.o : DEFAULT_FILENAME;
    fs.writeFileSync(
      WORKING_FOLDER + "/" + fileName,
      JSON.stringify(objectContext)
    );
  }
  templateEngine.render(objectContext, {
    helpers: { isManaged, isMetadataFormula, attributesFormula }
  });
  const intro = opciones.m ? opciones.m : DEFAULT_INTRO;
  templateEngine.save(intro, WORKING_FOLDER);
}

module.exports = {
  help,
  prompt,
  execute
};
