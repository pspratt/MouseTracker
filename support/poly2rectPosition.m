function rectPosition = poly2rectPosition(polyPosition)

%X min
rectPosition(1) = polyPosition(1,1);
%Y min
rectPosition(2) = polyPosition(1,2);
%width
rectPosition(3) = polyPosition(3,1) - polyPosition(1,1);
%height 
rectPosition(4) = polyPosition(3,2) - polyPosition(1,2);
