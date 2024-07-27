function main ()
  clear all;
  clf;
  f = figure (1);
  
  min = -25; 
  max = 25; 
  [x y] = meshgrid (min:0.5:max);
  
  % Define electric vector field
  x_E = @(x, y) -(sqrt(x.^2 + y.^2) - 10) .* (x ./ sqrt(x.^2 + y.^2)) - (y ./ sqrt(x.^2 + y.^2));
  y_E = @(x, y) -(sqrt(x.^2 + y.^2) - 10) .* (y ./ sqrt(x.^2 + y.^2)) + (x ./ sqrt(x.^2 + y.^2));
  E = quiver (x, y, x_E(x,y), y_E(x, y), color='b'); hold on
  % Define magnetic vector field
  x_B = @(x,y) x;
  y_B = @(x,y) y;
  B = quiver (x, y, x_B(x,y), y_B(x,y), color='r'); hold on

  % Define a particle p 
  q_p = 1.6e-19; % charge 
  m_p = 1.67e-27; % mass

  p_p = [ 1 1 ]; % position 
  v_p = [ 0 0 ]; % velocity

  % Get electric and magnetic field vectors at particle's position
  E_p = [ x_E(p_p(1), p_p(2)) y_E(p_p(1), p_p(2)) ];
  B_p = [ x_B(p_p(1), p_p(2)) y_B(p_p(1), p_p(2)) ];

  tic;

  % Draw initial particle 
  F_p = lorentz_force(q_p, v_p, E_p, B_p);
  p = quiver (p_p(1), p_p(2), F_p(1)/q_p, F_p(2)/q_p, 'k', "linewidth", 2); hold on
  xlim([min max]);
  ylim([min max]);

  while true
    dt = toc/1e4; tic;
  
    % Update particle position 
    u_p = v_p;
    v_p = u_p + (F_p(1:2)/m_p)*dt;
    p_p = p_p + (v_p + u_p)/2 * dt;
    
    % Get electric and magnetic field vectors at particle's position
    E_p = [ x_E(p_p(1), p_p(2)) y_E(p_p(1), p_p(2)) ];
    B_p = [ x_B(p_p(1), p_p(2)) y_B(p_p(1), p_p(2)) ];

    % Recalculate lorentz_force
    F_p = lorentz_force(q_p, v_p, E_p, B_p);
    
    % Redraw
    set (p, 'xdata', p_p(1))
    set (p, 'ydata', p_p(2))
    set (p, 'udata', F_p(1)/q_p)
    set (p, 'vdata', F_p(2)/q_p)

    pause (0.01)
  end
end

function F = lorentz_force (q, v, E, B)
  F = q*([ E 0 ] + cross([ v 0 ], [ B 0 ]));
end


