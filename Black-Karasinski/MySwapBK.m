function price = MySwapBK(StartDates,EndDates,ValuationDate,Compounding,Rates,vol,alpha,ExerciseDates,Maturity,stk)
%Rates = reshape( repmat(Rates, 4,1 ), 1, [] )';
RateSpec = intenvset('Rates', Rates, 'StartDates', StartDates, 'EndDates', EndDates,...
'Compounding', Compounding);

% use BKVolSpec to compute the interest-rate volatility
Volatility = reshape( repmat(vol', 4,1 ), 1, [] )';
AlphaCurve = alpha*ones(length(Volatility),1);  
AlphaDates = EndDates;  
BKVolSpec = bkvolspec(ValuationDate, EndDates, Volatility, AlphaDates, AlphaCurve); 

% use BKTimeSpec to specify the structure of the time layout for the BK interest-rate tree
BKTimeSpec = bktimespec(ValuationDate, EndDates, Compounding);

% build the BK tree
BKTree = bktree(BKVolSpec, RateSpec, BKTimeSpec);

% use the following arguments for a 1-year swap and 4-year swaption
SwapSettlement = ExerciseDates;  
Spread = 0;  
SwapReset = 4;   
Principal = 100;  
OptSpec = {'call'};    
Strike= stk;    
Basis=1; 
price = zeros(length(ExerciseDates),1);

% price the swaption
for i =1:length(ExerciseDates)
[p,pp] = swaptionbybk(BKTree, OptSpec, Strike(i), ExerciseDates(i), ...
        Spread, SwapSettlement(i), Maturity, 'SwapReset', SwapReset,'Basis',Basis, ...
        'Principal', Principal);
price(i) = p(1);
end
price'
a = [vol' alpha]
end