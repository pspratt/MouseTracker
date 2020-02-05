function [open1, open2, closed1, closed2, center, bg] = selectEPMarms(background,open1, open2, closed1, closed2, center)

if nargin < 2
    open1Pos = [281.5614  225.4386;...
                  281.5614   37.4386;...
                  350.2544   37.2719;...
                  350.2544  225.3421];
  
    open2Pos = [284.3684  457.2982;...
                  284.3684  269.2982;...
                  353.0614  269.1316;...
                  353.0614  457.2018];
              
    closed1Pos = [334.5351  263.5175;...
                  334.5351  224.2193;...
                  553.4825  224.2193;...
                  553.4825  263.5175];
    
    closed2Pos =  [89.2018  269.1316;...
                    89.2018  229.8333;...
                    301.9737  229.8333;...
                    301.9737  269.1316];
    
    centerPos = [301.4123  266.3246;...
                  301.4123  227.0263;...
                  335.6579  227.0263;...
                  335.6579  266.3246];
    
else
    open1Pos = open1.getPosition;
    open2Pos = open2.getPosition;
    closed1Pos = closed1.getPosition;
    closed2Pos = closed2.getPosition;
    centerPos = center.getPosition;
end
close all;
f1 = figure;
bg = imshow(background);
hold on;

open1 = impoly(gca,open1Pos);
open1.setColor('Red');

open2 = impoly(gca,open2Pos);
open2.setColor('Red');

closed1 = impoly(gca,closed1Pos);
closed1.setColor('Green');

closed2 = impoly(gca,closed2Pos);
closed2.setColor('Green');

center = impoly(gca,centerPos);
center.setColor('yellow');

title('Double-click center polygon to continue');
wait(center);

end
