function IOU=FindIOU(BB1,BB2)
BB1= cell2mat(BB1);
BB2= cell2mat(BB2);

disp(BB2);
IOU= bboxOverlapRatio(BB1,BB2);
end