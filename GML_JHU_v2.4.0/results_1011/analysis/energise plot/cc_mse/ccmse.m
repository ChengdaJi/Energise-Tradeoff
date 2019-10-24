fs = 17;
M = readmatrix("ccmse.csv");

detmin = M(13,:);



%sem cost
sems = [0.025 0.1 0.2]';

% sem_p75_cost = (M(1:3,1) - detmin(1))/ detmin(1)*100;
% sem_p100_cost = (M(1:3,2) - detmin(2))/detmin(2)*100;
sem_p75_cost = (M(1:3,1) - detmin(1));
sem_p100_cost = (M(1:3,2) - detmin(2));

subplot(2,1,1);
plot(sems,sem_p75_cost,'-*','LineWidth',3,'color','r')
hold on
plot(sems,sem_p100_cost,'-*','LineWidth',3,'color','#8DB600')
% ytickformat('percentage')
set(gca,'Ycolor','black','FontSize',20);
grid on
label = [ "50%", "75%"];
legend([label(1), label(2)]);
ylabel({'Cost Increase'},'Interpreter','latex','FontSize',fs,'Color','black');
xlabel('Normalized Solar Prediction Error Variance','Interpreter','latex','FontSize',fs,'Color','black');

% %sem solar
% 
% sem_p75_solar = M(1:3,3) ./ detmin(3);
% sem_p100_solar = M(1:3,4) ./ detmin(4);
% 
% subplot(2,2,3);
% plot(sems,sem_p75_solar*100,'-*','LineWidth',3,'color','r')
% hold on
% plot(sems,sem_p100_solar*100,'-*','LineWidth',3,'color','#8DB600')
% ytickformat('percentage')
% set(gca,'Ycolor','black','FontSize',20);
% grid on
% label = [ "50%", "75%"];
% legend([label(1), label(2)]);
% ylabel({'Solar Usage Ratio'},'Interpreter','latex','FontSize',fs,'Color','black');
% xlabel('Solar Variance','Interpreter','latex','FontSize',fs,'Color','black');
% ylim([90 101])


%cc cost
cc = [90 95 99]';

% cc_p75_cost = (M(9:11,1) - detmin(1))/ detmin(1)*100;
% cc_p100_cost = (M(9:11,2) - detmin(2))/detmin(2)*100;

cc_p75_cost = (M(9:11,1) - detmin(1));
cc_p100_cost = (M(9:11,2) - detmin(2));

subplot(2,1,2);
plot(cc,cc_p75_cost,'-*','LineWidth',3,'color','r')
hold on
plot(cc,cc_p100_cost,'-*','LineWidth',3,'color','#8DB600')
xtickformat('percentage')
% ytickformat('percentage')
set(gca,'Ycolor','black','FontSize',20);
grid on
label = [ "50%", "75%"];
legend([label(1), label(2)]);
ylabel({'Cost Increase'},'Interpreter','latex','FontSize',fs,'Color','black');
%ylabel('Cost Increasement\,\,[USD]','Interpreter','latex','FontSize',fs,'Color','black');
xlabel('Chance Constraint Confidence Level\,\,[\%]','Interpreter','latex','FontSize',fs,'Color','black');

%cc solar
cc = [90 95 99]';

cc_p75_solar = M(9:11,3) ./ detmin(3);
cc_p100_solar = M(9:11,4) ./ detmin(4);


% subplot(2,2,4);
% plot(cc,cc_p75_solar*100,'-*','LineWidth',3,'color','r')
% hold on
% plot(cc,cc_p100_solar*100,'-*','LineWidth',3,'color','#8DB600')
% set(gca,'Ycolor','black','FontSize',20);
% xtickformat('percentage')
% ytickformat('percentage')
% grid on
% label = [ "50%", "75%"];
% legend([label(1), label(2)]);
% %ylabel('Solar Usage\,\,[\%]','Interpreter','latex','FontSize',fs,'Color','black');
% xlabel('Chance Constraints','Interpreter','latex','FontSize',fs,'Color','black');
% ylim([90 101])
