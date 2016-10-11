%% ��������ռ��еı�����ͼ��
clear,clc
close all

%% 1.����337����ָ֤�����̼۸�
load elm_stock

whos
rng(now)
price=price(:);

train_num=280;
price1=price(1:train_num);  %ǰ280������Ϊѵ����
price2=price(train_num+1:337);      %���������Ϊ������

x=price1';
%[x,ps]=mapminmax(x,0,1);   %��һ��������������ӻ򲻼�

lag=6;    % �Իع����
iinput=x; % xΪԭʼ���У���������
n=length(iinput);

%׼��������������
inputs=zeros(n-lag,lag);
for i=1:n-lag
    inputs(i,:)=iinput(i:i+lag-1)';
end
targets=x(lag+1:end);

%��������
P=inputs;
P=P';
T=targets;
net=newff(minmax(P),[10,1],{'logsig','purelin'},'trainlm');
inputWeights=net.IW{1,1} ;
inputbias=net.b{1}; 
layerWeights=net.LW{2,1} ;
layerbias=net.b{2,1} ;

% �������ϣ�����ѵ�������Ժ���

net.trainParam.show = 50; 
net.trainParam.lr = 0.1; 
net.trainParam.mc = 0.04; 
net.trainParam.epochs = 1000; 
net.trainParam.goal = 1e-5; 


%ѵ������
[net,tr] = train(net,P,T);

%% ����ͼ���ж���Ϻû�
yn=net(P);
errors=T-yn;

figure(1)
plot(T,'b-');
hold on
plot(yn,'r--')
legend('�ɼ���ʵֵ','BP�������ֵ')
title('ѵ�����ݵĲ��Խ��');

% ��ʾ�������
mse1 = mse(errors);
fprintf('    mse = \n     %f\n', mse1)
figure(2)

title('ѵ�����ݲ��Խ���Ĳв�')



% ��ʾ������
disp('    �����')
fprintf('%f  ', (T - yn)./T );
fprintf('\n')

%% Ԥ��
% 2.��ʾ�������ݵĲ��Խ��

%Ԥ��
fn=57;  %Ԥ�ⲽ��Ϊfn��

f_in=iinput(n-lag+1:end)';
f_out=zeros(1,fn);  %Ԥ�����
% �ಽԤ��ʱ���������ѭ��������
for i=1:fn
    f_out(i)=net(f_in);
    f_in=[f_in(2:end);f_out(i)];
end
figure(3)
% ��ʾ��ʵֵ
x2=1:length(price2');
plot(price2,'b-');
hold on
% ��ʾ����������ֵ
plot(f_out,'r--')
legend('initial data','prediction result');
title('BP prediction');
hold off
grid on

% ��ʾ�в�
figure(4)
errors2=price2'-f_out;
mse2=mse(errors2);
plot(mse2)
title('�������ݲ��Խ���Ĳв�')

% ��ʾ�������
mse2 = mse(errors2);
fprintf('    mse = \n     %f\n', mse2)

% ��ʾ������
disp('    �����')
fprintf('%f  ', errors2./price2' );
fprintf('\n')



