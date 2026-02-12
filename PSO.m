clc
close all
%initialization
swarm_size = 64;        %jumlah partikel
maxIter = 10;           %jumlah iterasi 
inertia = 1.0;
correction_factor = 2.0;
%posisi awal swarm 
a = 1:8;
[X,Y] = meshgrid(a,a);
C = cat(2,X',Y');
D = reshape(C,[],2);
swarm(1:swarm_size,1,1:2) = D;      %posisi awal partikel
swarm(:,2,:) = 0;                   %velocity awal partikel
swarm(:,4,1) = 1000;                %posisi terbaik saat ini
plotObjFcn = 1;
%%fungsi
objfcn = @(x)(x(:,1) - 20).^2 + (x(:,2) - 25).^2
tic;
%%iterasi PSO
for iter = 1:maxIter
    swarm(:, 1, 1) = swarm(:, 1, 1) + swarm(:, 2, 1)/1.3;
    swarm(:, 1, 2) = swarm(:, 1, 2) + swarm(:, 2, 2)/1.3;
    x = swarm(:, 1, 1);
    y = swarm(:, 1, 2);
    fval = objfcn([x,y]);
    
    
    for i = 1:swarm_size
        if fval(i,1) < swarm(i,4,1)
            swarm (:, 3, 1) = swarm(:, 1, 1);
            swarm (:, 3, 2) = swarm(:, 1, 2);
            swarm (:, 4, 1) = fval(:, 1);
        end
    end
    
    [~, gbest] = min(swarm(:, 4, 1));
    
    %update velocity
    swarm(:, 2, 1) = inertia*(rand(swarm_size,1).*swarm(:, 2, 1)) + correction_factor*(rand(swarm_size,1).*(swarm(:, 3, 1)... 
        - swarm(:, 1, 1))) + correction_factor*(rand(swarm_size,1).*(swarm(gbest, 3, 1) - swarm(:, 1, 1)));
    swarm(:, 2, 2) = inertia*(rand(swarm_size,1).*swarm(:, 2, 2)) + correction_factor*(rand(swarm_size,1).*(swarm(:, 3, 2)... 
        - swarm(:, 1, 2))) + correction_factor*(rand(swarm_size,1).*(swarm(gbest, 3, 2) - swarm(:, 1, 2)));
    
    %plot Partikel
    clf;plot(swarm(:, 1, 1), swarm(:, 1, 2), 'bx'); grid
    axis([0 40 0 40]);
    xlabel('x1')
    ylabel('x2')
    pause(.5);
    disp(['iteration: ' num2str(iter)]);
    
end
toc
if plotObjFcn
    ub = 40;
    lb = 0;
    npoints = 1000;
    x = (ub-lb) .* rand(npoints,2) + lb;
    for i = 1:npoints
        f = objfcn([x(i,1) x(i,2)]);
        plot3(x(i,1),x(i,2),f,'.r'); hold on
    end
    plot3(swarm(1,3,1),swarm(1,3,2),swarm(1,4,1),'xb','linewidth',5,'Markersize',5);grid
end 