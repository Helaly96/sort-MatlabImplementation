function BB=ConvertBoxToSR(BoundingBox)
Width= BoundingBox(3)-BoundingBox(1);
Height= BoundingBox(4)-BoundingBox(2);
X= BoundingBox(1) + Width/2;
Y= BoundingBox(2) + Height/2;
S= Width*Height;
R= Width/Height;
BB=[X,Y,S,R];
end
