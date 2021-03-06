% FORCESENSORSSERVER - create a server to listen for connections and sample the DAQ card
%
% d = forcesensorsserver(port,maxsamplerate,channels,range,parameters,sampleContinuously,numChannelsTotal,debug)
%
% parameters should be a 2 x N matrix (N is the number of channels)
% The first row is the offset, the second row the gain (Force in N = gain * (voltage - offset) )
%
% channels should be a 1 x 2 matrix, with [minChannelNumber maxChannelNumber]
%
% If channels is a cell array, this indicates that you can also send digital outputs (e.g. triggers)
% The first value should be the same as channels described above, and the second the channels for the digital output, 
% where 1 = AUXPORT1, etc. e.g. {[1 3],1}
%
% The server will sample as fast as possible, so specify in
% maxsamplerate the maximum it will do (to avoid buffer overflows)
%
% numChannelsTotal - set the total number of channels on the device. This
% will usually determine whether the device records in differential mode or
% not (e.g. for the USB-1608G, 8 = differential, 16 = single-sided)
%
%
% e.g.
% d = forcesensorsserver(3001,6000,[0 4],4,[0 0 0 0 0; 1 1 1 1 1],0,8);
% listen(d);

function d = forcesensorsserver(port,samplerate,channels,range,parameters,sampleContinuously,numChannelsTotal,debug)

if nargin<7 || isempty(debug)
    debug = 0;
end

d.parameters = parameters;
d.codes = messagecodes;
d.sampleContinuously = sampleContinuously;
d.numChannelsTotal = numChannelsTotal;

if ~all(size(channels)==[1 2])
    error('Channels must be a 1x2 matrix');
end

channels
parameters
if iscell(channels)
    inputchannels = channels{1};
else
    inputchannels = channels;
end

if ~all(size(parameters)==[2 (inputchannels(2)-inputchannels(1)+1)])
    error('Parameters must be a 2xN matrix (N=number of channels)');
end

if iscell(channels)
    d = class(d,'forcesensorsserver',DAQserver(port,samplerate,channels,'',5,range,debug));
else
    d = class(d,'forcesensorsserver',DAQserver(port,samplerate,channels,'',4,range,debug));
end