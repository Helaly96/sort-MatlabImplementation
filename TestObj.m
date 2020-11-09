% This class represents the internal state of individual tracked objects observed as bbox.
classdef TestObj
    properties
        Counter=NaN;
    end
    
    methods
        function obj= TestObj()
                 obj.Counter=0;
        end
        
        function obj=AddtoMe(obj)
                 obj.Counter= obj.Counter+1;
        end
    end       
end


