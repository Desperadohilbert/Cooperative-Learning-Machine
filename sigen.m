function [d, e0] = sigen(x, w0, model)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIGNAL GENERATOR.

% DESCRIPTION:
% Generates a desired signal starting from the input signal and the impulse
% response.
%
%
% INPUT PARAMETERS:
%   x: excitation signal - clear far end signal
%   w0: impulse response
%
% OUTPUT PARAMETERS:
%   d: desired signal (signal convolved with the room impulse response and
%      possible summed with background noise and/or near end signal)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Lx = length(x);                                                         % Length of the input signal
d = zeros(Lx, 1);                                                       % Desired signal initialization
% x = x/max(abs(x));                                                    % Normalized input signal


switch model
    
    case 1  % Linear case
        dx = filter(w0, 1, x);                                          % Desired signal for the linear path without additive noise
        e0 = awgn(dx, 20, 'measured') - dx;                             % Additive noise: white Gaussian white noise providing 20 dB SNR
        d = dx + e0;                                                    % Desired signal for the linear path with additive noise
        
    case 2  % Soft clipping with th = 1/2
        dxL = filter(w0, 1, x);                                         % Desired signal for the linear path without additive noise
        e0 = awgn(dxL, 20, 'measured') - dxL;                           % Additive noise: white Gaussian white noise providing 20 dB SNR
        xn = symclipth(x, 1/2);                                         % Distorted signal by symmetrical soft clipping
        dx = filter(w0, 1, xn);                                         % Distorted signal convolved with the linear path
        d = dx + e0;                                                    % Desired signal for the linear path + soft clipping
        
    case 3  % Soft clipping with th = 0.1
        dxL = filter(w0, 1, x);                                         % Desired signal for the linear path without additive noise
        e0 = awgn(dxL, 20, 'measured') - dxL;                           % Additive noise: white Gaussian white noise providing 20 dB SNR
        xn = symclipth(x, 0.1);                                         % Distorted signal by symmetrical soft clipping
        dx = filter(w0, 1, xn);                                         % Distorted signal convolved with the linear path
        d = dx + e0;                                                    % Desired signal for the linear path + soft clipping

    case 4  % Soft clipping with th = 1/20
        dxL = filter(w0, 1, x);                                         % Desired signal for the linear path without additive noise
        e0 = awgn(dxL, 20, 'measured') - dxL;                           % Additive noise: white Gaussian white noise providing 20 dB SNR
        xn = symclipth(x, 1/20);                                        % Distorted signal by symmetrical soft clipping
        dx = filter(w0, 1, xn);                                         % Distorted signal convolved with the linear path
        d = dx + e0;                                                    % Desired signal for the linear path + soft clipping

    case 5  % Loudspeaker distortion model memoryless
        dxL = filter(w0, 1, x);                                         % Desired signal for the linear path without additive noise
        e0 = awgn(dxL, 20, 'measured') - dxL;                           % Additive noise: white Gaussian white noise providing 20 dB SNR
        dx = zeros(Lx, 1);
        alfa1 = 4; 
        alfa2 = 0.5;
        G = 2;
        for n = 1 : Lx
            xx = 1.5*x(n) - 0.3*x(n)^2;
            if (xx > 0) 
                alfa = alfa1; 
            else
                alfa = alfa2;
            end
            dx(n) = G*(1/(1 + exp(-alfa*xx)) - 0.5);
        end
        dx = filter(w0, 1, dx);                                         % Distorted signal convolved with the linear path
        d = dx + e0;                                                    % Desired signal for the linear path + soft clipping

    case 6  % Dynamic loudspeaker distortion model with memory order = 5
        dxL = filter(w0, 1, x);                                         % Desired signal for the linear path without additive noise
        e0 = awgn(dxL, 20, 'measured') - dxL;                           % Additive noise: white Gaussian white noise providing 20 dB SNR
        dx = zeros(Lx, 1);
        alfa1 = 4; 
        alfa2 = 0.5;
        G = 2;
        x1 = 0;  x2 = 0; x3=0; x4=0;  x5=0;
        for n = 1 : Lx
            xx = 1.5*x(n) - 0.3*x(n)^2 + 1.8*x(n)*x1  + 0.5*x(n)*x2 ...
                - 0.4*x(n)*x3 - 1.5*x1*x2 + 0.9*x(n)*x1*x3  + 0.5*x1*x2*x3 ...
                - 0.1*x1^2 + 0.2*x2^2 - 0.1*x3^2 + 0.3*x3*x4 - 1.2*x4^2  ... 
                + 0.2*x1*x5 + 0.3*x3*x5 + 1.2*x5^2;
            if (xx > 0) 
                alfa = alfa1; 
            else
                alfa = alfa2;
            end
            dx(n) = G*(1/(1 + exp(-alfa*xx)) - 0.5);
            x5 = x4;
            x4 = x3;
            x3 = x2;
            x2 = x1 ;
            x1 = x(n);
        end
        dx = filter(w0, 1, dx);                                         % Distorted signal convolved with the linear path
        d = dx + e0;                                                    % Desired signal for the linear path + soft clipping

        
    case 7  % Dynamic loudspeaker distortion model with memory order = 2
        dxL = filter(w0, 1, x);                                         % Desired signal for the linear path without additive noise
        e0 = awgn(dxL, 20, 'measured') - dxL;                           % Additive noise: white Gaussian white noise providing 20 dB SNR
        dx = zeros(Lx, 1);
        alfa1 = 4; 
        alfa2 = 0.5;
        G = 2;
        x1 = 0;  x2 = 0;
        for n = 1 : Lx
            xx = 1.5*x(n) - 0.3*x(n)^2 + 1.8*x(n)*x1  + 0.5*x(n)*x2 ...
                - 1.5*x1*x2 - 0.1*x1^2 + 0.2*x2^2;
            if (xx > 0) 
                alfa = alfa1; 
            else
                alfa = alfa2;
            end
            dx(n) = G*(1/(1 + exp(-alfa*xx)) - 0.5);
            x2 = x1 ;
            x1 = x(n);
        end
        dx = filter(w0, 1, dx);                                         % Distorted signal convolved with the linear path
        d = dx + e0;                                                    % Desired signal for the linear path + soft clipping
        
end
