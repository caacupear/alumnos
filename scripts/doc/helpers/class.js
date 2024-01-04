const sf = require("./connect");
const prompts = require("prompts");
const templateEngine = require("./template")("dictionary", "md");
const {
  getContextCache,
  sortByLabel,
  DICTIONARY_FOLDER,
  WORKING_FOLDER,
  DEFAULT_INTRO
} = require("./util");
const DEFAULT_FILENAME = ".classes.json";
const fs = require("fs");

async function getClasses(clases) {
  try {
    await sf.connect();
    const objects = await sf.customObjects(objetos);

    return objects;
  } catch (e) {
    console.error(e);
  }
}

async function prompt(config) {}

async function getContext(items, opciones) {
  let contexts;

  // flag -i lee del archivo cache
  if (opciones && "i" in opciones) {
    const allClasses = getContextCache(
      opciones.i ? opciones.i : DEFAULT_FILENAME
    );
    contexts = allClasses.filter((object) => items.includes(object.fullName));
  } else if (opciones && "r" in opciones) {
    // flag -r lee del archivo cache pero vuelve a buscar la metadata
    contexts = getContextCache(opciones.r ? opciones.r : DEFAULT_FILENAME);
    const itemsEnCache = contexts.map((clase) => clase.developerName);
    contexts = await getClasses(itemsEnCache);
  } else {
    // Sino buscar la metadata segun los items
    contexts = await getClasses(items);
  }

  if (contexts && !Array.isArray(contexts)) {
    contexts = [contexts];
  }
  return contexts;
}

function help() {
  console.log(
    "Este comando se conecta a la metadata de las clases de Salesforce (fuentes) y en base a los templates genera:"
  );
  console.log(
    "1. Por cada clase usa el template class.md para crear un diccionario de datos de la clase en la carpeta " +
      DICTIONARY_FOLDER
  );
  console.log(
    "2. Crea un indice en la working folder usando el template classes.md"
  );
  console.log(
    "\nPuede llamarse para un objeto o varios, de la siguiente forma:"
  );
  console.log("npm run doc class AccountController.cls");
  console.log("npm run doc class AccountController.cls CaseController.cls");
}

async function execute({ items, opciones }) {
  // Busca la metadata
  const contexts = await getContext(items, opciones);

  if (!contexts || contexts.length === 0) {
    return;
  }
  // Arma el diccionario de cada Objeto
  templateEngine.read("class");
  for (const context of contexts) {
    templateEngine.render(context, {
      helpers: {}
    });
    templateEngine.save(context.fullName, DICTIONARY_FOLDER);
  }
  // Arma el documento indice del grupo de objetos
  contexts.sort(sortByLabel);
  templateEngine.read("classes");
  const objectContext = { objects: contexts };

  if ("o" in opciones) {
    const fileName = opciones.o ? opciones.o : DEFAULT_FILENAME;
    fs.writeFileSync(
      WORKING_FOLDER + "/" + fileName,
      JSON.stringify(objectContext)
    );
  }
  templateEngine.render(objectContext, {
    helpers: {}
  });
  const intro = opciones.m ? opciones.m : DEFAULT_INTRO;
  templateEngine.save(intro, WORKING_FOLDER);
}

module.exports = {
  prompt,
  help,
  execute
};
