
function help() {
    console.error('Puede llamarse con el api name de un objeto o varios, de la siguiente forma:');
    console.error('Ej single object: npm run generate datos objeto');
    console.error('Ej multi object: npm run generate datos objeto1 objeto2 objeto3');
}

async function execute( clases) {

}

module.exports = {
    help,
    execute
};