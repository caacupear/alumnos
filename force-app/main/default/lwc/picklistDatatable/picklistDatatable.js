import LightningDatatable from 'lightning/datatable';
import picklistColumn from './picklistColumn.html';
import picklistStatic from './picklistStatic.html'
import picklistColorStatic from './picklistColorStatic.html';
import colorStatic from './colorStatic.html';

export default class PicklistDatatable extends LightningDatatable {
    static customTypes = {
        picklistColumn: {
            template: picklistStatic,
            editTemplate: picklistColumn,
            standardCellLayout: true,
            typeAttributes: ['label', 'placeholder', 'options', 'value', 'context', 'variant','name', 'ranges']
        },
        colorColumn: {
            template: colorStatic,
            standardCellLayout: true,
            typeAttributes: ['label', 'ranges', 'value', 'options', 'context', 'variant','name']
        }, 
        colorPicklistColumn: {
            template: picklistColorStatic,
            editTemplate: picklistColumn,
            standardCellLayout: true,
            typeAttributes: ['label', 'placeholder', 'options', 'value', 'context', 'variant','name']
        }
    };
}