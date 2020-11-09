function [Matches,UnmatchedDetections,UnmatchedTrackers,IOUMatrix]=AssociateDetectionToTrackers(Detections,Trackers,IouThreshold)
if    (isempty(Trackers))
      Matches= int8.empty(0,2);
      UnmatchedDetections= 1:length(Detections);
      UnmatchedTrackers=int8.empty(0,4);  
      IOUMatrix=NaN;
      return;
end

%Find the Overlap ratio between the trackers and the detections
IOUMatrix= FindIOU(Detections,Trackers);

%perform the Hungarian algorithm which ensure Optimal Linear Assignment
if    min(size(IOUMatrix))>0
      a= IOUMatrix>IouThreshold;
      % I -> Detections 
      % J -> Trackers
      [I,J]= LinearSumassignment(-IOUMatrix); 
else
      Matches= int8.empty(0,2);
end

UnmatchedDetections=[];

for    i=1:length(Detections) 
       %Check if the current detection is matched
       if    ~any(ismember(I,i))
             UnmatchedDetections(end+1)= i;
       end
end

UnmatchedTrackers=[];

for    j=1:length(Trackers) 
       %Check if the current detection is matched
       if    ~any(ismember(J,j))
             UnmatchedTrackers(end+1)= i;
       end
end

Matches={};
for t=1:length(I)
    if    IOUMatrix(I(t),J(t))<IouThreshold
          UnmatchedDetections(end+1)= I(t);
          UnmatchedTrackers(end+1)= J(t);
    else
          Matches{end+1}=[I(t) J(t)];
    end
end

if    (length(Matches)==0)
      Matches= int8.empty(0,2);
end

end