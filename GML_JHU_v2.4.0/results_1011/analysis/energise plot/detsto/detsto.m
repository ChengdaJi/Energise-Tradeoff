fs = 20;

p = [25, 50, 75, 100];

M = readmatrix("detsto.csv");
%cost
subplot(1,2,1);
plot(p,M(1,:),'-*','LineWidth',3,'color','#008000')
hold on
plot(p,M(2,:),'--','LineWidth',3,'color','#CC5500')
xtickformat('percentage')
set(gca,'Ycolor','black','FontSize',20);
grid on
label = ["Online", "Offline"];
legend([label(1), label(2)]);
ylabel('Cost\,\,[USD]','Interpreter','latex','FontSize',fs,'Color','black');
xlabel('Solar Penetration','Interpreter','latex','FontSize',fs,'Color','black');
xlim([0 100])

%solar usage
subplot(1,2,2);
plot(p,(M(3,:)./M(5,:))*100,'-*','LineWidth',3,'color','#008000')
hold on
plot(p,(M(4,:)./M(5,:))*100,'--','LineWidth',3,'color','#CC5500')
xtickformat('percentage')
ytickformat('percentage')
set(gca,'Ycolor','black','FontSize',20);
grid on
label = ["Online", "Offline"];
legend([label(1), label(2)]);
ylabel('Solar Usage Ratio','Interpreter','latex','FontSize',fs,'Color','black');
xlabel('Solar Penetration','Interpreter','latex','FontSize',fs,'Color','black');
xlim([0 100])
ylim([90 100])