function polyPosition = rect2polyPosition(rectPosition)


polyPosition(1,1) = rectPosition(1);
polyPosition(1,2) = rectPosition(2);

polyPosition(2,1) = rectPosition(1) + rectPosition(3);
polyPosition(2,2) = rectPosition(2);

polyPosition(3,1) = rectPosition(1) + rectPosition(3);
polyPosition(3,2) = rectPosition(2) + rectPosition(4);

polyPosition(4,1) = rectPosition(1);
polyPosition(4,2) = rectPosition(2) + rectPosition(4);


