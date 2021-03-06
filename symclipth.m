function y = symclipth(x, th)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% "Overdrive" simulation with symmetrical soft clipping.
%
%
% DESCRIPTION:
% Up to the threshold of th the input is multiplied by two and the
% characteristic curve is in the linear region. Between input values of th
% up to 1-th, the characteristic curve produces a soft compression. Above
% the input value of 1-th the output value is set to 1.
%
% INPUT PARAMETERS:
%   x: excitation signal - clear far end signal
%   th: nonlinearity threshold
%
% OUTPUT PARAMETERS:
%   y: output distorted signal
%
%
% REFERENCES:
%   [1] U. Z�lzer, X. Amatriain, "DAFX: Digital Audio Effects", John Wiley
%       and Sons, 2002.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Initialization

N = length(x);                                                            % Input signal length
y = zeros(N,1);                                                           % Output signal initialization
if nargin < 2
    th = 1/20;                                                            % Default threshold for symmetrical soft clipping by Schetzen Formula
end
xn = x/max(abs(x));                                                       % Normalized input signal


% Main

for i = 1:N
   
    if abs(xn(i)) < th
       y(i) = 2*xn(i);
   end
   if abs(xn(i)) >= th
      if xn(i) > 0
          y(i) = (3 - (2 - xn(i)*3).^2)/3;
      end
      if xn(i) < 0
          y(i) = - (3 - (2 - abs(xn(i))*3).^2)/3;
      end
   end
   if abs(xn(i)) > 2*th
      if xn(i) > 0
          y(i) = 1;
      end
      if xn(i) < 0
          y(i) = -1;
      end
   end
end