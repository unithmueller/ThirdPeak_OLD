function D = appUtilsEstimateD(trajectories, DinEll, ellips, Flag3d)
  %constrained and 2d
            trajectories = trajectories.trajs;
            if DinEll == 1 && Flag3d == 0
                d = [0.0 0.0];
                cpt = 0;
                trajids = unique(trajectories(:,1));
                for i = 1:size(trajids,2)
                    singletraj = trajectories(trajids(i),:);
                    for j = 1:length(singletraj,1)-1
                        p1 = singletraj(j);
                        p2 = singletraj(j+1);
                        if ellips.inside(p1(1,3:4)) && ellips.inside(p2(1,3:4))
                            step  = p2(1,3:4) - p1(1,3:4);
                            dif = step.^2/(p2(1,2)-p1(1,2));
                            d = d + dif;
                            cpt = cpt+1;
                        end
                    end
                end
                D = (d(1) + d(2))/(4*cpt);
                
                %constrained and 3d
            elseif DinEll == 1 && Flag3d == 1
                d = [0.0 0.0 0.0];
                cpt = 0;
                trajids = unique(trajectories(:,1));
                for i = 1:size(trajids,2)
                    singletraj = trajectories(trajids(i),:);
                    for j = 1:length(singletraj,1)-1
                        p1 = singletraj(j);
                        p2 = singletraj(j+1);
                        if ellips.inside(p1(1,3:5)) && ellips.inside(p2(1,3:5))
                            step  = p2(1,3:5) - p1(1,3:5);
                            dif = step.^2/(p2(1,2)-p1(1,2));
                            d = d + dif;
                            cpt = cpt+1;
                        end
                    end
                end
                D = (d(1) + d(2) + d(3))/(6*cpt);
                
                %unconstrained and 2d
            elseif DinEll == 0 && Flag3d == 0
                d = [0.0 0.0];
                cpt = 0;
                trajids = unique(trajectories(:,1));
                for i = 1:size(trajids,2)
                    singletraj = trajectories(trajids(i),:);
                    for j = 1:length(singletraj,1)-1
                        p1 = singletraj(j);
                        if ellips.inside(p1(1,3:4))
                            p2 = singletraj(j+1);
                            step  = p2(1,3:4) - p1(1,3:4);
                            dif = step.^2/(p2(1,2)-p1(1,2));
                            d = d + dif;
                            cpt = cpt+1;
                        end
                    end
                end
                D = (d(1) + d(2))/(4*cpt);
                
                %unconstrained and 3d
            elseif DinEll == 0 && Flag3d == 1
                d = [0.0 0.0 0.0];
                cpt = 0;
                trajids = unique(trajectories(:,1));
                for i = 1:size(trajids,2)
                    singletraj = trajectories(trajids(i),:);
                    for j = 1:length(singletraj,1)-1
                        p1 = singletraj(j);
                        if ellips.inside(p1(1,3:5))
                            p2 = singletraj(j+1);
                            step  = p2(1,3:5) - p1(1,3:5);
                            dif = step.^2/(p2(1,2)-p1(1,2));
                            d = d + dif;
                            cpt = cpt+1;
                        end
                    end
                end
                D = (d(1) + d(2) + d(3))/(6*cpt);
            end