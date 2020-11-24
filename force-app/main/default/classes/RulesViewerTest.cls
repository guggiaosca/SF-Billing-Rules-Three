@isTest
private class RulesViewerTest {
    
    @isTest
    static void validateGetRulesTree(){
        Product2 prd = [
            Select Id From Product2 Limit 1
        ];

        String returnedJson = RulesViewer.getRulesTree(prd.Id);
        System.debug(returnedJson);

    }

    @testSetup 
    static void setup() {
        SBQQ.TriggerControl.disable();

        blng__BillingRule__c billingRule = new blng__BillingRule__c();
        billingRule.Name = 'test Billing Rule';
        billingRule.blng__Active__c = true;
        billingRule.blng__GenerateInvoices__c = 'No';
        billingRule.blng__InitialBillingTrigger__c = 'Order Product Activation Date';
        insert billingRule;

        blng__TaxRule__c taxRule = new blng__TaxRule__c();
        taxRule.Name = 'Test Tax Rule';
        taxRule.blng__Active__c = true;
        insert taxRule;

        blng__RevenueRecognitionRule__c revRule = new blng__RevenueRecognitionRule__c();
        revRule.Name = 'Test Rev Rec';
        revRule.blng__Active__c = true;
        revRule.blng__CreateRevenueSchedule__c = 'Yes'; 
        insert revRule;

        Pricebook2 pb = new Pricebook2();
        pb.Name = 'Test PB';
        pb.IsActive = true;
        insert pb;

        Product2 product = new Product2();
        product.Name = 'Test Product';
        product.ProductCode = 'Test';
        product.IsActive = True;
        product.blng__BillingRule__c = billingRule.Id;
        product.blng__TaxRule__c = taxRule.Id;
        product.blng__RevenueRecognitionRule__c = revRule.Id;
        insert product;

        PricebookEntry pbeStandard = new PricebookEntry();
        pbeStandard.Product2Id = product.Id;
        pbeStandard.Pricebook2Id = Test.getStandardPricebookId();
        pbeStandard.IsActive = true;
        pbeStandard.UnitPrice = 100;
        pbeStandard.UseStandardPrice = false;
        insert pbeStandard;

        blng__GLAccount__c glAccountDebit = new blng__GLAccount__c();
        glAccountDebit.Name = 'TestDebit';
        glAccountDebit.blng__Active__c = true;
        glAccountDebit.blng__GLAccountNumber__c = '98765';
        insert glAccountDebit;

        blng__GLAccount__c glAccountCredit = new blng__GLAccount__c();
        glAccountCredit.Name = 'TestCredit';
        glAccountCredit.blng__Active__c = true;
        glAccountCredit.blng__GLAccountNumber__c = '98764';
        insert glAccountCredit;

        blng__GLRule__c rule = new blng__GLRule__c();
        rule.Name = 'test rule';
        rule.blng__Active__c = true;
        insert rule;

        blng__GLTreatment__c treatment = new blng__GLTreatment__c();
        treatment.Name = 'Test Treatment';
        treatment.blng__CreditGLAccount__c = glAccountCredit.Id;
        treatment.blng__DebitGLAccount__c = glAccountDebit.Id;
        treatment.blng__GLRule__c = rule.Id;
        insert treatment; 

        blng__RevenueDistributionMethod__c rdm = new blng__RevenueDistributionMethod__c();
        rdm.Name = 'Test Method';
        rdm.blng__Active__c = true;
        rdm.blng__MonthlyRecognitionProration__c = 'Number of Days';
        rdm.blng__RevenueTransactionCreationProcess__c = 'Automatic';
        rdm.blng__Type__c = 'Order';
        rdm.blng__DistributionMethod__c = 'Daily';
        rdm.blng__RevenueScheduleTermStartDate__c = 'Order Product Start Date';
        rdm.blng__RevenueScheduleTermEndDate__c = 'Order Product End Date';
        insert rdm;

        blng__FinanceBook__c fb = new blng__FinanceBook__c();
        fb.Name = 'Test FB';
        fb.blng__FinancePeriodDuration__c = 'Monthly';
        fb.blng__PeriodType__c = 'Revenue';
        insert fb;

        blng__FinancePeriod__c fp = new blng__FinancePeriod__c();
        fp.Name = 'Test Finance Period';
        fp.blng__FinanceBook__c = fb.Id;
        fp.blng__PeriodStatus__c = 'Closed';
        fp.blng__PeriodStartDate__c = Date.newInstance(2020, 10, 1);
        fp.blng__PeriodEndDate__c = Date.newInstance(2020, 10, 31);
        insert fp;

        blng__RevenueRecognitionTreatment__c rrt = new blng__RevenueRecognitionTreatment__c();
        rrt.Name = 'Test RRT';
        rrt.blng__Active__c = true;
        rrt.blng__RevenueDistributionMethod__c = rdm.Id;
        rrt.blng__Type__c = 'Percentage';
        rrt.blng__Percentage__c = 100;
        rrt.blng__RevenueScheduleCreationAction__c = 'Order Activation';
        rrt.blng__RevenueDistributionMethod__c = rdm.id;
        rrt.blng__RevenueRecognitionRule__c = revRule.Id;
        rrt.blng__ProcessingOrder__c = 2;
        rrt.blng__RevenueFinanceBook__c = fb.Id;
        rrt.blng__RevenueGLRule__c = rule.Id;
        insert rrt;

       
    
    }

}