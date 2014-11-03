% GETSINGLESAMPLE -  get the latest sample of data (when in continous mode)
% To get a sample when not running continuously, use getsinglesample
%
% [data,framenumber] = getsample(k,nummarkers)
%
% It should produce a 1xN array of data

function [data,framenumber] = getsample(ts,nummarkers)

% Initialize a struct to put the results in 
result = struct(libstruct('tagDOUBLE_POSITION_ANGLES_TIME_Q_RECORD_AllSensors_Four'));
resultPointer = libpointer('tagDOUBLE_POSITION_ANGLES_TIME_Q_RECORD_AllSensors_Four', result);
% Read all 4 markers (even if not connected)
handleError(ts,calllib(ts.libstring, 'GetSynchronousRecord',  hex2dec('ffff'), resultPointer, 64*4));

result = get(resultPointer,'value');

n = 8;
for k=0:nummarkers-1
    data(1,k*n+1:(k+1)*n) = [result.(['x' num2str(k)]) result.(['y' num2str(k)]) result.(['z' num2str(k)]) ...
        result.(['a' num2str(k)]) result.(['e' num2str(k)]) result.(['r' num2str(k)]) ...
        result.(['quality' num2str(k)]) result.(['time' num2str(k)])];
end

framenumber = result.time0;