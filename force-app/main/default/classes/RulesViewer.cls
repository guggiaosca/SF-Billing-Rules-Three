public  class RulesViewer {

    @AuraEnabled(cacheable=true)
    public static List<treeItem> getRulesTree(Id productId){
        Product2 product = [
            Select
                Id,
                Name,
                blng__BillingRule__c,
                blng__TaxRule__c,
                blng__RevenueRecognitionRule__c
            From Product2
            Where Id = :productId
        ];

        List<blng__BillingRule__c> lstBillingRule = getBillingRules(product.blng__BillingRule__c);
        List<blng__TaxRule__c> lstTaxRule = getTaxRules(product.blng__TaxRule__c);
        List<blng__RevenueRecognitionRule__c> lstRevRecRule = getRevRecRules(product.blng__RevenueRecognitionRule__c);

        List<treeItem> lstRules = new List<treeItem>();
        treeItem rules = new treeItem();
        rules.name = product.Id;
        rules.label = product.Name;
        rules.expanded = true;

        for(blng__BillingRule__c br : lstBillingRule){
            treeItem brItem = new treeItem();
            brItem.name = br.Id;
            brItem.label = br.Name;
            brItem.expanded = false;
            brItem.metatext = 'Billing Rule';

            for(blng__BillingTreatment__c bTreat : getBillingTreatment(br.Id)){
                treeItem btItem = new treeItem();
                btItem.name = bTreat.Id;
                btItem.label = bTreat.Name + '(' + bTreat.blng__BillingLegalEntity__r.Name + ')';
                btItem.expanded = false;
                btItem.metatext = 'Billing Treatment';

                treeItem glrule = new treeItem();
                glrule.name = bTreat.blng__BillingGLRule__c;
                glrule.label = bTreat.blng__BillingGLRule__r.Name;
                glrule.expanded = false;
                glrule.metatext = 'Billing GL Rule';

                for(blng__GLTreatment__c glTreat : getGLTreatment(bTreat.blng__BillingGLRule__c)){
                    treeItem node =  getGLTreatmentTree(glTreat);
                    glrule.items.add(node);
                }
                
                btItem.items.add(glrule);
                brItem.items.add(btItem);
            }

            rules.items.add(brItem);
        }

        for(blng__TaxRule__c tr : lstTaxRule){
            treeItem trItem = new treeItem();
            trItem.Name = tr.Id;
            trItem.label = tr.Name;
            trItem.expanded = false;
            trItem.metatext = 'Tax Rule';
            for(blng__TaxTreatment__c tTreat : getTaxTreament(tr.Id)){
                treeItem ttItem = new treeItem();
                ttItem.name = tTreat.Id;
                ttItem.label = tTreat.Name + '(' + tTreat.blng__TaxLegalEntity__r.Name + ')';
                ttItem.expanded = false;
                ttItem.metatext = 'Tax Treatment';
                treeItem glrule = new treeItem();
                glrule.name = tTreat.blng__TaxGLRule__c;
                glrule.label = tTreat.blng__TaxGLRule__r.Name;
                glrule.expanded = false;
                glrule.metatext = 'Tax GL Rule';

                for(blng__GLTreatment__c glTreat : getGLTreatment(tTreat.blng__TaxGLRule__c)){
                    treeItem node =  getGLTreatmentTree(glTreat);
                    glrule.items.add(node);
                }

                ttItem.items.add(glrule);

                trItem.items.add(ttItem);
            }
            rules.items.add(trItem);
        }

        for(blng__RevenueRecognitionRule__c rrr : lstRevRecRule){
            treeItem rrItem = new treeItem();
            rrItem.name = rrr.Id;
            rrItem.label = rrr.Name;
            rrItem.expanded = false;
            rrItem.metatext = 'Revenue Recognition Rule';
            for(blng__RevenueRecognitionTreatment__c rrTreat : getRevRecTreatment(rrr.Id)){
                treeItem rrt = new treeItem();
                rrt.name = rrTreat.Id;
                rrt.label = rrTreat.Name + '(' + rrTreat.blng__RevenueLegalEntity__r.Name + ')';
                rrt.expanded = false;
                rrt.metatext = 'Revenue Recognition Treatment';
                treeItem glrule = new treeItem();
                glrule.name = rrTreat.blng__RevenueGLRule__c;
                glrule.label = rrTreat.blng__RevenueGLRule__r.Name;
                glrule.expanded = false;
                glrule.metatext = 'Revenue Recognition GL Rule';
                for(blng__GLTreatment__c glTreat : getGLTreatment(rrTreat.blng__RevenueGLRule__c)){
                    treeItem node =  getGLTreatmentTree(glTreat);
                    glrule.items.add(node);
                }
                rrt.items.add(glrule);
                rrItem.items.add(rrt);
            }
            rules.items.add(rrItem);
        }

        lstRules.add(rules);
        return lstRules;

    }

    private static treeItem getGLTreatmentTree (blng__GLTreatment__c glTreat){
        treeItem gl = new treeItem();
        gl.name = glTreat.Id;
        gl.label = glTreat.Name + '(' + glTreat.blng__GLLegalEntity__r.Name + ')';
        gl.expanded = false;
        gl.metatext = 'GL Treatment';
        treeItem glAccount = new treeItem();
        glAccount.name = glTreat.blng__CreditGLAccount__c + '|' + glTreat.blng__DebitGLAccount__c;
        glAccount.label = 'CR: ' + glTreat.blng__CreditGLAccount__r.Name + ' - DB: ' + glTreat.blng__DebitGLAccount__r.Name;
        glAccount.expanded = false;
        glAccount.metatext = 'GL Accounts';
        gl.items.add(glAccount);
        return gl;
    }

    private static List<blng__BillingRule__c> getBillingRules(Id billingRuleId){
        List<blng__BillingRule__c> blRules = [
            SELECT 
                Id,
                Name
            From blng__BillingRule__c
            Where Id = :billingRuleId
        ];

        return blRules;

    }

    private static  List<blng__TaxRule__c> getTaxRules(Id taxRuleId){
        List<blng__TaxRule__c> taxRules = [
            SELECT 
                Id,
                Name
            From blng__TaxRule__c
            Where Id = :taxRuleId
        ];

        return taxRules;
    }

    private static List<blng__RevenueRecognitionRule__c> getRevRecRules(Id revRecRuleId){
        List<blng__RevenueRecognitionRule__c> rrRules = [
            SELECT 
                Id,
                Name
            From blng__RevenueRecognitionRule__c
            Where Id = :revRecRuleId
        ];

        return rrRules;
    }

    private static List<blng__BillingTreatment__c> getBillingTreatment(Id billingRuleId){
        List<blng__BillingTreatment__c> bTreatments = [
            Select
                Id,
                Name,
                blng__BillingGLRule__c,
                blng__BillingGLRule__r.Name,
                blng__BillingLegalEntity__c,
                blng__BillingLegalEntity__r.Name
            From blng__BillingTreatment__c
            Where blng__BillingRule__c = :billingRuleId
        ];

        return bTreatments;
    }

    private static List<blng__TaxTreatment__c> getTaxTreament(Id taxRuleId){
        List<blng__TaxTreatment__c> tTreat = [
            Select Id,
                Name,
                blng__TaxGLRule__c,
                blng__TaxGLRule__r.Name,
                blng__TaxLegalEntity__c,
                blng__TaxLegalEntity__r.Name
            From blng__TaxTreatment__c
            Where blng__TaxRule__c = :taxRuleId
        ];

        return tTreat;

    }

    private static List<blng__RevenueRecognitionTreatment__c> getRevRecTreatment(Id revRecRuleId){
        List<blng__RevenueRecognitionTreatment__c> rrTreat = [
            Select Id,
                Name,
                blng__RevenueGLRule__c,
                blng__RevenueGLRule__r.Name,
                blng__RevenueLegalEntity__c,
                blng__RevenueLegalEntity__r.Name
            From blng__RevenueRecognitionTreatment__c
            Where blng__RevenueRecognitionRule__c = :revRecRuleId
        ];

        return rrTreat;

    }

    private static List<blng__GLTreatment__c> getGLTreatment (Id glRuleId){
        List<blng__GLTreatment__c> glTreat = [
            Select Id,
                Name,
                blng__GLLegalEntity__c,
                blng__GLLegalEntity__r.Name,
                blng__CreditGLAccount__c,
                blng__CreditGLAccount__r.Name,
                blng__DebitGLAccount__c,
                blng__DebitGLAccount__r.Name
            From blng__GLTreatment__c
            Where blng__GLRule__c = :glRuleId
        ];

        return glTreat;
    }

    public class treeItem {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Boolean expanded;
        @AuraEnabled
        public String metatext;
        @AuraEnabled
        public List<treeItem> items;
        public treeItem(){
            this.label = '';
            this.name = '';
            this.expanded = false;
            this.metatext = '';
            items = new List<treeItem>();
        }
    }
}