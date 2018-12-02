ValuationDate = 'Apr-20-2018';
Settle = ValuationDate;
ExerciseDate = daysadd(Settle,90*(4:4:40),1);
Maturity = 'Apr-20-2029';
%Settle = ValuationDate;
StartDates = daysadd(Settle,90*(0:43),1);
EndDates = daysadd(Settle,90*(1:44),1);
% tempRates = [0.027115 	0.027925	0.028276	0.0284389	0.02854...
%             0.0286205	0.028708	0.028813	0.028923];
% temp = reshape( repmat(tempRates, 4,1 ), 1, [] )';
% Rates = [0.0235539;0.0237468;0.0248892;0.0261782;0.0272139;0.0280463;0.0286756;...
%         temp;0.02905];
tempRates = [0.0271481 	0.0279928	0.0283583	0.0285411	0.0286468...
            0.0287380	0.0288383	0.0289608 0.0290831];
temp = reshape( repmat(tempRates, 4,1 ), 1, [] )';
Rates = [0.0235866;0.0242732;0.0246391;0.0251006;0.0257108;0.0262663;0.0267001;...
        temp;0.0292266];
Compounding = 4;
Basis = 1; 

RateSpec = intenvset('ValuationDate', ValuationDate, 'StartDates', StartDates, ...
'EndDates', EndDates, 'Rates', Rates, 'Compounding', Compounding,'Basis', Basis);
RateSpecblk = intenvset('ValuationDate', ValuationDate, 'StartDates', ValuationDate, ...
'EndDates', EndDates, 'Rates', Rates, 'Compounding', Compounding,'Basis', Basis);

stk = [3.031282	3.020666 3.008069 2.990536 2.974978	2.963653 2.95639 2.953905 2.955488 2.948769]./100;
stk = flipud(stk')';
vol_blk = [25.75 23.73 24.17 24.19 24.44 26 25.85 25.59 23.01 21.49]./100;
vol_blk = flipud(vol_blk')';
Principal = 100;
Reset = 4;
OptSpec = 'call';
Price = zeros(10,1);

for i = 1:10
    Price(i) = swaptionbyblk(RateSpecblk, OptSpec, stk(i), Settle,  ExerciseDate(i), ...
        Maturity, vol_blk(i),'Basis', Basis, 'Reset', Reset,'Principal', Principal);
end

% objfunc = @(x) MySwapBK(StartDates,EndDates,ValuationDate,Compounding,Rates,ones(11,1)*x(1)...
%                         ,x(2),ExerciseDate,Maturity,stk) - Price;

objfunc = @(x) MySwapBK(StartDates,EndDates,ValuationDate,Compounding,Rates,[((1:6)*(x(2) - x(1))*0.2 + 1.2*x(1) - 0.2*x(2)),...
                        (7:11)*(x(3) - x(2))*0.2 + 2.2*x(2) - 1.2*x(3)]'...
                        ,x(4),ExerciseDate,Maturity,stk) - Price + 0.02*(x(2) - x(1))^2 + 0.02*(x(3) - x(2))^2+...
                        0.004*(x(3) - 2*x(2) + x(1))^2;
                    
% objfunc = @(x) MySwapBK(StartDates,EndDates,ValuationDate,Compounding,Rates,[(1:11)*(x(2) - x(1))*0.1 + 1.1*x(1)-0.1*x(2) ]...
%                         ,x(3),ExerciseDate,Maturity,stk) - Price + 0.02*(x(2) - x(1))^2 + 0.02*(x(3) - x(2))^2+...
%                         0.004*(x(3) - 2*x(2) + x(1))^2;
test = lsqnonlin(objfunc,0.1*ones(1,4),[0,0,0,0],[1,1,1,1]);