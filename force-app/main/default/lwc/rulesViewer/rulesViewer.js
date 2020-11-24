import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getRulesTree from '@salesforce/apex/RulesViewer.getRulesTree';

export default class RulesViewer extends NavigationMixin(LightningElement) {
    @api recordId;
    
    items = [];
    selectedItemValue;
    recordPageUrl;
    
    @wire(getRulesTree, {productId: '$recordId'})
    wiredRules({ error, data }) {
        if (data) {
            this.items = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.paymentMethods = undefined;
        }
    }

    setSelectedItem (event){
        console.log(event);
        var expectedItem = this.findNested2(this.items[0], 'name', event.detail.name);
        this.selectedItemValue = expectedItem.name;
    }

    handleClick(){
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.selectedItemValue,
                actionName: 'view',
            },
        }).then(url => {
            this.recordPageUrl = url;
            window.open(url, '_blank');
        });
    }

    findNested2(obj, key, value) {
        let found;
        
        if (obj[key] === value) {
            return obj;
        }
        const objKeys = Object.keys(obj);
        if (typeof obj['items'] === 'object' || Array.isArray(obj['items'])) {
            obj['items'].forEach(element => {
                if(!found){
                    found = this.findNested2(element, key, value);
            }
                return found;
            });
        }
        
        return found ? found : null;
    }
}