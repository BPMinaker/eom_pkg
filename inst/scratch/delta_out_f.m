function [ err ] = delta_out_f( delta_out2,delta_in,gamma,L1,L2 )
%delta_out_f Computes outer wheel steer angle for the input inner wheel
%steer angle
%   Computes outer wheel steer angle for the input inner wheel
%steer angle
err=sin(gamma-delta_out2)+sin(gamma+delta_in)-L1/L2+sqrt((L1/L2-2*sin(gamma))^2-(cos(gamma-delta_out2)-cos(gamma+delta_in))^2);
end

