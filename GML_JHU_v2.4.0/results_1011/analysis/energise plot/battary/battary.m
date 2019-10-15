fs = 20;
M = readmatrix("battary.csv");

%Battary Capacity
bc = [3 15 30]';


p25_cost = M(1:3,2);
p50_cost = M(1:3,3);
p75_cost = M(1:3,4);
p100_cost = M(1:3,5);

% % figure(1)
% % hold on
% % plot(bc,p25_cost,'-*','LineWidth',3,'color','#3C69E7')
% % plot(bc,p50_cost,'-*','LineWidth',3,'color','#ED9121')
% % plot(bc,p75_cost,'-*','LineWidth',3,'color','r')
% % plot(bc,p100_cost,'-*','LineWidth',3,'color','#8DB600')
% % set(gca,'Ycolor','black','FontSize',20);
% % grid on
% % label = ["25%", "50%", "75%", "100%"];
% % legend([label(1), label(2), label(3), label(4)]);
% % ylabel('Cost \,\,[USD]','Interpreter','latex','FontSize',fs,'Color','black');
% % xlabel('Battery Capacity\,\,[MWHr]','Interpreter','latex','FontSize',fs,'Color','black');


bc = [0.45 2 4]';
figure(2)
ax = axes
xtickformat(ax,'percentage')

hold on
plot(bc,p25_cost,'-*','LineWidth',3,'color','#3C69E7')
plot(bc,p50_cost,'-*','LineWidth',3,'color','#ED9121')
plot(bc,p75_cost,'-*','LineWidth',3,'color','r')
plot(bc,p100_cost,'-*','LineWidth',3,'color','#8DB600')
set(gca,'Ycolor','black','FontSize',20);
grid on
label = ["25%", "50%", "75%", "100%"];
legend([label(1), label(2), label(3), label(4)]);
ylabel('Cost \,\,[USD]','Interpreter','latex','FontSize',fs,'Color','black');
xlabel('Battery Penetration','Interpreter','latex','FontSize',fs,'Color','black');
ylim([-3000 30000])

p25_costin = M(5:7,2)*100;
p50_costin = M(5:7,3)*100;
p75_costin = M(5:7,4)*100;
p100_costin = M(5:7,5)*100;

figure(3)
hold on
plot(bc,p25_costin,'-*','LineWidth',3,'color','#3C69E7')
plot(bc,p50_costin,'-*','LineWidth',3,'color','#ED9121')
plot(bc,p75_costin,'-*','LineWidth',3,'color','r')
plot(bc,p100_costin,'-*','LineWidth',3,'color','#8DB600')
ytickformat('percentage')
xtickformat('percentage')
set(gca,'Ycolor','black','FontSize',20);
grid on
label = ["25%", "50%", "75%", "100%"];
legend([label(1), label(2), label(3), label(4)]);
ylabel({'Relative Cost Increase'},'Interpreter','latex','FontSize',fs,'Color','black');
xlabel('Battery Penetration','Interpreter','latex','FontSize',fs,'Color','black');
