function main ()
  clear all;
  clf;
  f = figure (1);
  
  min = -10; 
  max = 10; 
  [x y] = meshgrid (min:0.5:max);
  
  % Define electric vector field
  x_E = @(x,y) 0*(x+0.001)^2+0.5;
  y_E = @(x,y) (y+0.005)^2+0.5;
  E = quiver (x, y, x_E(x,y), y_E(x, y), color='b'); hold on
  % Define magnetic vector field
  x_B = @(x,y) 0*x;
  y_B = @(x,y) 0*y;
  B = quiver (x, y, x_B(x,y), y_B(x,y), color='r'); hold on

  % Define a particle p 
  q_p = 1.6e-19; % charge 
  m_p = 9.11e-31; % mass

  p_p = [ 0 0 ]; % position 
  v_p = [ 10 1 ]; % velocity

  % Get electric and magnetic field vectors at particle's position
  E_p = [ x_E(p_p(1), p_p(2)) y_E(p_p(1), p_p(2)) ];
  B_p = [ x_B(p_p(1), p_p(2)) y_B(p_p(1), p_p(2)) ];

  tic;

  % Draw initial particle 
  F_p = lorentz_force(q_p, v_p, E_p, B_p);
  p = quiver (p_p(1), p_p(2), F_p(1)/q_p, F_p(2)/q_p, 'k', "linewidth", 12); hold on
  xlim([min max]);
  ylim([min max]);

  while true
    dt = toc/1e5; tic;
  
    % Update particle position 
    u_p = v_p;
    v_p = u_p + (F_p(1:2)/m_p)*dt;
    p_p = (v_p + u_p)/2 * dt;
    
    % Get electric and magnetic field vectors at particle's position
    E_p = [ x_E(p_p(1), p_p(2)) y_E(p_p(1), p_p(2)) ]
    B_p = [ x_B(p_p(1), p_p(2)) y_B(p_p(1), p_p(2)) ];

    % Recalculate lorentz_force
    F_p = lorentz_force(q_p, v_p, E_p, B_p);
    
    % Redraw
    set (p, 'xdata', p_p(1))
    set (p, 'ydata', p_p(2))
    set (p, 'udata', F_p(1)/q_p)
    set (p, 'vdata', F_p(2)/q_p)

    pause (0.001)
  end
end

function F = lorentz_force (q, v, E, B)
  F = q*([ E 0 ] + cross([ v 0 ], [ B 0 ]));
end


