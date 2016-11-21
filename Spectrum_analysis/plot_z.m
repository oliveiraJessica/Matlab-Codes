
function plot_z( p,z )
figure;
plot(real(p), imag(p),'x');
hold on;
plot(real(z), imag(z),'o');
theta = 0:0.01:2*pi;
plot(cos(theta), sin(theta));
axis('square'); grid on;
axis([-1.5 1.5 -1.5 1.5])
xlabel('real'); ylabel('imag');
title('pole-zero plot');

end