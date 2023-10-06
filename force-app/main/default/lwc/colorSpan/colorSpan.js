import { LightningElement, api } from 'lwc';

export default class ColorSpan extends LightningElement {
    @api value;
    _options = [];
    _colorsByValue = {};
    _colorsByRange = [];
    
    /**
     * @param {[{ from?: Number, to?: Number, color:String}]} values
     */
    @api 
    set ranges(values){
        if ( values ) {
            this._colorsByRange = values;
        }
    }

    get ranges() {
        return this._colorsByRange;
    }

    get color() {
        if ( this._colorsByValue && this._colorsByValue[this.value]) {
            return this._colorsByValue[this.value];
        }
        if ( this._colorsByRange ) {            
            for(const option of this._colorsByRange) {
                const isOver = !option.from || this.value >= option.from;
                const isBellow = !option.to || this.value < option.to;
                if (  isOver && isBellow ){
                    return option.color;
                }
            }
        }
        return 'default';
    } 

    /**
     * @param {[{ value: String, color:String}]} values
     */
    @api 
    set options(values){
        if ( values ) {
            this._options = values;
            this._colorsByValue = {};
            for(const option of values) {
                this._colorsByValue[option.value] = option.color;
            }
        }
    }

    get options() {
        return this._options;
    }

    get computedClass() {        
        return `slds-truncate color-${this.color}`;
    }    
}