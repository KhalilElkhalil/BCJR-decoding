%********************************************************************************%
%                                     BCJR_conv Decoder
%
% This algorithm is reserved to the implementation of the Bahl, Cocke, Jelinek and Raviv (BCJR)
% algorithm. This function takes as input the channel output (corrupted
% data) and the a priori prob (we will set it to 1/2) and returns as output
% the APP Log Liklihood Ratio (LLR) for every data input. It is usually called a
% Soft Input Soft Output (SISO) decoder. It can be applied to any code
% having a finite state machine, in our case we will use it for rate-1/n convolutional codes.
%
%                                              K. Elkhalil, SUP'COM Tunisia 2012.
%                				               Updated in Feb 2019. 
% *******************************************************************************%
function LLR=BCJR_conv(y,trellis,sigma)
N=length(y); % y is the channel output
n=log2(trellis.numOutputSymbols);
k=log2(trellis.numInputSymbols); % k=1
R=k/n; % coding rate, R=1/n
LLR=zeros(1,N*R);
Pap=0.5; % The a priori probability.
%********* Computing gamma for all states at each time ***************
gamma=zeros(N*R,trellis.numStates,trellis.numStates); % we suppose that the first state is the 0 state which can be handled at the encoders.
    for k=1:N*R
        for s=1:trellis.numStates
            for ss=1:trellis.numStates
            [msg,in]=ismember(ss-1,trellis.nextStates(s,:));
            if msg==1
                gamma(k,ss,s)=0.5*((1/sqrt(2*pi*sigma^2))^n)*exp(-sum((y(n*k-n+1:n*k)-(1-2*binary(trellis.outputs(s,in),n))).^2)/2/sigma^2) ;
            end
            end
        end
    end
%************** alpha recursions********************
alpha=zeros(N*R+1,trellis.numStates);
alpha(1,1)=1;
    for k=2:N*R+1
        for ss=1:trellis.numStates
            for s=1:trellis.numStates
                alpha(k,ss)=alpha(k,ss)+gamma(k-1,ss,s)*alpha(k-1,s) ;
            end
        end
        alpha(k,:)=alpha(k,:)/sum(alpha(k,:)); % Normalization
    end
%************** beta recursions********************
beta=zeros(N*R+1,trellis.numStates);
beta(N*R+1,:)=alpha(N*R+1,:);
    for k=N*R+1:-1:2
        for ss=1:trellis.numStates
            for s=1:trellis.numStates
                beta(k-1,ss)=beta(k-1,ss)+gamma(k-1,s,ss)*beta(k,s) ;
            end
        end
        beta(k-1,:)=beta(k-1,:)/sum(beta(k-1,:)) ; % Normalization
    end
%%%%%%%%%%%%%%%%%%% Computing the LLRs %%%%%%%%%%%%%%%
    for k=1:N*R
        up=0;
        down=0;
         for s=1:trellis.numStates
            for ss=1:trellis.numStates
            [msg,in]=ismember(ss-1,trellis.nextStates(s,:));
            if (msg==1 && in==1) % input=0
               up=up+alpha(k,s)*gamma(k,ss,s)*beta(k+1,ss);
            else if (msg==1 && in==2) % input=1
                    down=down+alpha(k,s)*gamma(k,ss,s)*beta(k+1,ss);
                end
            end
            end
         end
        LLR(k)=log(up/down);
    end

end
