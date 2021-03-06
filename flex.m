function g = flex(xBuff, Mi, Me, exord, memord, exp_type)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTIONAL LINK EXPANSION

% DESCRIPTION:
% This function creates the enhanced buffer according to the type of 
% expansion passed as parameter.
%
%
% INPUT PARAMETERS:
%   xBuff: input buffer to the linear filter
%   Mi: length of the input buffer to the FLAF selected for the expansion
%   Me: length of the expanded buffer
%   exord: expansion order
%   memord: memory order of the filter
%   exp_type: expansion type - options: '1'=Trigonometric, '2'=Chebyshev,
%       '3'=Legendre
%
%
% OUTPUT PARAMETERS:
%   g: expanded buffer
%
%
% REFERENCES:
%   [1] D. Comminiello, L.A. Azpicueta-Ruiz, M. Scarpiniti, A. Uncini and 
%       J. Arenas- Garc�a, "Functional Link Adaptive Filters for 
%       Nonlinear Acoustic Echo Cancellation", in IEEE Transactions on 
%       Audio, Speech and Language Processing, vol. 21, no. 7, pp. 
%       1502-1512, July 2013.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Initialization

g = zeros(Me,1);                                                           % Expanded buffer initialization

%----------Trigonometric functional link expansion-------------------------------------------------------------------------------------------------%
if exp_type == 1
    exord2 = 2*exord;                                                      % Number of sin and cos for trigonometric expansion
    deltac = exord2 - 1;                                                   % Auxiliary index for trigonometric functional expansion
    c = 0;                                                                 % Counter variable for the index of expanded vector (j in paper)
    for i = 1:Mi                                                           % Read the input buffer untill Mi-th sample
        for j = 1:exord                                                    % j in papers is called little p
            c = c + 1;
            if c > Me, break, end
            a = j*pi;
            g(c) = sin(a*xBuff(i));                                        % Compute the sin function
            c = c + 1;
            if c > Me, break, end
            g(c) = cos(a*xBuff(i));                                        % Compute the cos function
        end
        for k = 1:memord
            if i > k
                c = c + 1;
                if c > Me, break, end
                if memord == 1
                    b = c - (2*exord2 + min((i-1)-memord,memord)*exord2);  % To optimize....
                else
                    b = c - (2*exord2 + min(i-memord,memord)*exord2);
                end
                if c + deltac > Me, deltac = Me - c; end
                g(c:c+deltac) = xBuff(i)*g(b:b+deltac);                    % Compute the functional links with memory
                c = c + deltac;
            else break
            end
        end
    end
    
%----------Chebyshev functional link expansion------------------------------------------------------%
elseif  exp_type == 2
    c = 0;                                                                                          % Counter variable for the index of expanded vector
    for i = 1:Mi                                                                                    % Read the input buffer untill Mi-th sample
        g1 = xBuff(i);                                                                              % Initialization of the first past sample
        g2 = 1;                                                                                     % Initialization of the second past sample
        for j = 1:exord
            c = c + 1;
            if c > Me, break, end
            g(c) = 2*xBuff(i)*g1 - g2;                                                              % Compute the output sample
            g2 = g1;                                                                                % Shift memory
            g1 = g(c);                                                                              % Shift memory
        end
    end
    
%----------Legendre functional link expansion-------------------------------------------------------%
elseif  exp_type == 3
    c = 0;                                                                                          % Counter variable for the index of expanded vector
    for i = 1:Mi                                                                                    % Read the input buffer untill Mi-th sample
        g1 = xBuff(i);                                                                              % Initialization of the first past sample
        g2 = 1;                                                                                     % Initialization of the second past sample
        for j = 1:exord
            c = c + 1;
            if c > Me, break, end
            g(c) = ((2*j - 1)*xBuff(i)*g1 - (j-1)*g2)/j;                                            % Compute the output sample
            g2 = g1;                                                                                % Shift memory
            g1 = g(c);                                                                              % Shift memory
        end
    end
    
    
%----------Volterra expansion-----------------------------------------------------------------------%
elseif exp_type == 4
        c = 0;
        for i = 1:Mi
            g1 = xBuff(i);
            g2 = 1;
            for j = 1:exord
                c = c+1;
                if c > Me, break, end
                g(c) = 
            end
        end
end
    
