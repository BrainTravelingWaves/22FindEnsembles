%% Load parametrs
Nchn=306; %All chan
NchnG=204; % Gradientometer chan
Srate=1000; 
t0=0;  % MEG analis interval
tn=0.8; 
%% Word list
% Number of lists=3
Nwords=8;
%         m1         m2      m3  
wrdl={'zavitoy','vozmojn','vzaimny';
      'kudryav','dostupn','dvoyaky';
      'petlaus','pravdop','dvukrat';
      'kurchav','pronicm','sdvoeny';
      'vyazany','sudohod','dvoichn';
      'pleteny','realizm','oboudny';
      'volnist','osushes','dvuliky';
      'kruchen','vypolnm','dvoistv'};
%% Load data
% Nrepeats=5;
% Number of words in the list=8
for isqu=1:3 % 1-m1 2-m2 3-m3
    if isqu==1 
       wrd=[4,10,15,17,19;  % 104 110....
            9,27,36,40,42;
            5,14,23,28,43;
            6,12,29,37,38;
            7,16,21,22,33;
            8,20,30,35,41;
            11,13,25,26,39;
            18,24,31,32,34];
       m=m1;
    end
    if isqu==2  
       wrd=[7,18,20,22,34; % 207 218....+++3
            9,17,21,39,40;
            11,14,28,29,32;
            4,24,35,41,42;
            5,13,15,27,43;
            6,19,26,30,38;
            8,10,12,16,37;
            23,25,31,33,36];
       m=m2;
    end
    if isqu==3  
       wrd=[12,22,29,35,43; % 312 322....+++3
            11,21,24,25,33;
            5,20,27,30,31;
            4,8,18,32,40;
            6,7,19,36,41;
            9,10,16,23,28;
            13,14,17,26,39;
            15,34,37,38,42];
       m=m3;
    end
%% Find labeles numbers 
   stimulus=m.Events(1).times;
   Nsignal=size(m.Time,2);
   [Nstr,Nwrd]=size(wrd);
   tTime=zeros(Nstr,Nwrd);
   for i=1:Nstr
       for j=1:Nwrd
           jj=1;
           while jj < Nsignal+1
              if m.Time(jj) > stimulus(wrd(i,j))
                 break  
              end
              jj=jj+1;
           end
           tTime(i,j)=jj;
       end
   end
%%
%Srate=1000; 
%t0=0;
%tn=0.8;
%NchnG=204;
   for iwrd=1:Nstr %Nwords
       name_word=wrdl{iwrd,isqu};
       for irpd=1:Nwrd %Nrepeats    
       %% Load gradientometrs signal one word
           SigG=zeros(NchnG,(tn-t0)*Srate);
           tw=tTime(iwrd,irpd);
           j=1;
           for i=1:Nchn
               jj=mod(i,3);
               if jj==1
                  SigG(j+1,:)=m.F(i,tw:tw+size(SigG,2)-1);
                  j=j+1;
               end    
               if jj==2
                  SigG(j-1,:)=m.F(i,tw:tw+size(SigG,2)-1);
                  j=j+1;
               end    
           end
%% Sort std Sig
           StdSig=zeros(NchnG,1);
           for i=1:NchnG
               StdSig(i)=std(SigG(i,:));
           end
           [StdSig,StdSgn]=sort(StdSig,'descend');
%% Find clasters
           clsG=zeros(fix(NchnG/2));
           trhR=0.7;
           trhP=0.01;
%% Create clasters
           Ncls=1;
           while size(StdSgn,1)>1
                 N=size(StdSgn,1);
                 clsG(Ncls,1)=StdSgn(N);
                 j=2;
                 for i=1:N-1
                     [cri,cpi]=corr(SigG(StdSgn(N),:)',SigG(StdSgn(i),:)');
                     if cri>trhR
                        if cpi<trhP 
                           clsG(Ncls,j)=StdSgn(i);
                           StdSgn(i)=0;
                           j=j+1;
                        end
                     end
                 end
                 StdSgn(N)=0;
                 StdSgn(StdSgn==0)=[]; %delete null
                 Ncls=Ncls+1;
            end
%% Find triplets
            clsGTr=round(clsG/2);
            clsGTg=mod(clsG,2);
            for j=1:fix(NchnG/2)
                for i=1:fix(NchnG/2)
                    clsGTr(i,j)=clsGTr(i,j)*10+3;
                    if clsGTg(i,j)==0
                       clsGTr(i,j)=clsGTr(i,j)-1;
                    end
                end
             end
%% Save triplets
             name_triplets=strcat(name_word,num2str(irpd),'.mat');
             save(name_triplets,'clsGTr')
       end
   end
end