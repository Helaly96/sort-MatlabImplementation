function BoundingBox=ConvertSRToBox(BoundingBox)
Width= sqrt(BoundingBox(3) * BoundingBox(4));
Height= BoundingBox(3) / Width;
X1=BoundingBox(1)-(Width/2);
Y1=BoundingBox(2)-(Height/2);
X2=BoundingBox(1)+(Width/2);
Y2=BoundingBox(2)+(Height/2);
BoundingBox=[X1,Y1,X2,Y2];
end
