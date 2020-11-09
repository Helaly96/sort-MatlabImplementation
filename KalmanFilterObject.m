% This class represents the internal state of individual tracked objects observed as bbox.
classdef KalmanFilterObject
    properties
        % TrackingKF Object
        Kf= NaN
        % id that represents the object
        id= NaN
        %Time since the last update
        TimeSinceUpdate=0;
        % How many time it's been detected
        Hits= 0;
        % How many times back to back it's detected.
        HitsStreak= 0;
        % How long have we seen the object
        Age= 0;
        % History
        Hisory={}
        
    end
    
    methods
        function obj= KalmanFilterObject(id,InitialBoundingBox)
                 %7 and 4 are the number of states and measurement respectively according to the SORT paper [https://arxiv.org/pdf/1602.00763.pdf] 
                 
                 % State Transition Matrix
                 F= [1 0 0 0 1 0 0; 0 1 0 0 0 1 0 ;0 0 1 0 0 0 1; 0 0 0 1 0 0 0; 0 0 0 0 1 0 0; 0 0 0 0 0 1 0; 0 0 0 0 0 0 1];
                 % Measurement Function
                 H= [1 0 0 0 0 0 0; 0 1 0 0 0 0 0;0 0 1 0 0 0 0; 0 0 0 1 0 0 0];
                 obj.Kf= trackingKF(F,H);
                 
                 %Inits for the Measurment noise [Copied from the python implementation of the paper]
                 obj.Kf.MeasurementNoise(3:4, 3:4)=  obj.Kf.MeasurementNoise(3:4, 3:4)*10;
                 
                 %give high uncertainty to the unobservable initial velocities
                 obj.Kf.StateCovariance(5:7,5:7)= obj.Kf.StateCovariance(5:7,5:7) * 1000;
                 obj.Kf.StateCovariance(5:7,5:7)= obj.Kf.StateCovariance(5:7,5:7) * 10;
                 
                 %Inits for the Process Noise 
                 obj.Kf.ProcessNoise(end,end)= obj.Kf.ProcessNoise(end,end)*0.01;
                 obj.Kf.ProcessNoise(5:7,5:7)= obj.Kf.ProcessNoise(5:7,5:7)*0.01;
                 
                 %Set the ID of the object
                 obj.id= id;
                 
                 %Set the state of the object to be equal to the initial bounding box
                 obj.Kf.State(1:4)= ConvertBoxToSR(InitialBoundingBox);          
        end
        
        % Update step in Kalman Filter
        function [Correction,obj]= KalmanFilterobjectUpdate(obj,BoundingBox)
                 %Reset the last seen timer
                 obj.TimeSinceUpdate= 0;
                 obj.Hits= obj.Hits+1;
                 obj.HitsStreak= obj.HitsStreak+1;
                 %Update the Kalman filter with the new measurment
                 Correction=correct(obj.Kf,ConvertBoxToSR(BoundingBox));
            
        end
        
        % Prediction Step in Kalman filter
        function [Prediction,obj]=KalmanFilterobjectPredict(obj)
                 if     (obj.Kf.State(6)+(obj.Kf.State(2))<=0)
                        obj.Kf.State(6)= obj.Kf.State(6)*0;
                 end
                 % Prediction Function call
                 Prediction=predict(obj.Kf);
                 obj.Age= obj.Age+1;
                 if     (obj.TimeSinceUpdate>0)
                        obj.HitsStreak=0;
                 end
                 obj.TimeSinceUpdate=obj.TimeSinceUpdate+1;
                 obj.Hisory{obj.Age}= obj.Kf.State;
                 
        end
        
        function BoundingBox= GetCurrentBoundingBoxEstimate(obj)
                 BoundingBox= ConvertSRToBox(obj.Kf.State);
        end
        
    end
end
