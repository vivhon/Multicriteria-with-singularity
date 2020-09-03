tic
clc;
% clear;
[data] = imp();
load('seed.mat');
rng(seed);
% seed=rng;
%===========**FOR K**======================================================
 maxk=700;
 mink=1;
 step=1;
%===========** FOR Item-CF **==============================================
 ik=160;
 cu=1;

%==========================================================================
 crv=3; % cross validation
 w=-100;
 maxo=13;                                     
 mino=0;                                     
 max=1;                                     
 min=0;
 sp=3;
 ci=1;  % common item
%============**Recommendations**===========================================
 minrec=1;                                % minimum recommendation
 maxrec=25;                                % maximum recommendation
 rr=12;                                    % relevant rating
 nrr=((max-min)/(maxo-mino))*(rr-maxo)+(max); 
 srr=12;                                   % significance relevant rating
 snrr=((max-min)/(maxo-mino))*(srr-maxo)+(max); 
%===================================regn in matlab=========================                          
 [data]=nonrating(data,0,w);   
 [data]=norma(data,maxo,mino,max,min,w); 
 [m,n,q]=size(data);
 d=5;
 clear nonratong norma;
%==========================================================================
 coverage=zeros(maxk/step,4);
 MAERROR=zeros(maxk/step,4);
%  precision=zeros(maxrec*maxk/step,5);
%  Recall=zeros(maxrec*maxk/step,5);
 
 Acoverage=zeros(maxk/step,7);
 AMAERROR=zeros(maxk/step,7);
%  Aprecision=zeros(maxrec*maxk/step,8);
%  ARecall=zeros(maxrec*maxk/step,8);
%  AFPR=zeros(maxrec*maxk/step,8);
%  AFmeas=zeros(maxk*maxrec/step,8);
 
 Ucoverage = zeros(m,7,(maxk-mink+1)/step);
 Umae = zeros(m,7,(maxk-mink+1)/step);
%  Urecall = zeros(m,7,(maxrec-minrec+1),(maxk-mink+1)/step);
%  Uprec = zeros(m,7,maxrec-minrec+1,(maxk-mink+1)/step);
%  Ufpr = zeros(m,7,maxrec-minrec+1,(maxk-mink+1)/step);
%==========================================================================
for r=1:crv % loop for cross validation
%--------------------------------------------------------------------------     
    [act,pass,actmin,actmax] = actpass(data,r,crv,w);
    clear actpass;
    
    [train,test]=split(act,sp,w,d);            
    clear split;
%==========================================================================
    [stru,spau,si]=signif(train,pass,snrr,w,d);
    [strain,spass] = SigICF(stru,spau,si,train,pass,w,ik,cu,q);
    [strain]=nonrating(strain,0,w);   
    [spass]=nonrating(spass,0,w);
%==========================================================================
%     [corms]=CorMs(train,pass,ci,w);              
%     clear CorMs;
%     disp("cormsend"); %**%
    [corcos]=CorCos(train,pass,ci,w);              
    clear CorCos;
    disp("corcosend"); %**%
    [corpe]=CorPear(train,pass,ci,w);               
    clear CorPear;
    disp("corpeend"); %**%
    %======================================================================
%     [scorms]=CorMs(strain,spass,ci,w);              
%     clear CorMs;
%     disp("scormsend"); %**%
    [scorcos]=CorCos(strain,spass,ci,w);              
    clear CorCos;
    disp("scorcosend"); %**%
    [scorpe]=CorPear(strain,spass,ci,w);               
    clear CorPear;
    disp("scorpeend"); %**%
%**************************************************************************
    for k=step:step:maxk
        l=k/step;
%==========================================================================
       Ucoverage(actmin:actmax,1,l)=(actmin:actmax)';
       Umae(actmin:actmax,1,l)=(actmin:actmax)';
%==========================================================================
%         [neims]=NeiMs(corms,k,w);
%         clear NeiMs;
        [neicos]=NeiCos(corcos,k,w);
        clear NeiCos;
        [neipe]=NeiPear(corpe,k,w);
        clear NeiPear;
        %==================================================================
%         [sneims]=NeiMs(scorms,k,w);
%         clear NeiMs;
        [sneicos]=NeiCos(scorcos,k,w);
        clear NeiCos;
        [sneipe]=NeiPear(scorpe,k,w);
        clear NeiPear;
%==========================================================================
%         [predms,covms,ucovms]=predict(pass,train,test,neims,corms,k,w,d);        
%         [Ucoverage] = aggregation(Ucoverage,ucovms,l,2,actmin,actmax);
%         clear predict aggregation;
        %------------------------------------------------------------------
        [predcos,covcos,ucovcos]=predict(pass,train,test,neicos,corcos,k,w,d);
        [Ucoverage] = aggregation(Ucoverage,ucovcos,l,3,actmin,actmax);        
        clear predict aggregation;
        %------------------------------------------------------------------
        [predpe,covpe,ucovpe]=predict(pass,train,test,neipe,corpe,k,w,d);
        [Ucoverage] = aggregation(Ucoverage,ucovpe,l,4,actmin,actmax);
        clear predict aggregation;
        %==================================================================
%         [spredms,scovms,sucovms]=spredict(pass,train,test,sneims,scorms,si,k,w,d);
%         [Ucoverage] = aggregation(Ucoverage,sucovms,l,5,actmin,actmax);
%         clear spredict aggregation;
        %------------------------------------------------------------------
        [spredcos,scovcos,sucovcos]=spredict(pass,train,test,sneicos,scorcos,si,k,w,d);
        [Ucoverage] = aggregation(Ucoverage,sucovcos,l,6,actmin,actmax);       
        clear spredict aggregation;
        %------------------------------------------------------------------
        [spredpe,scovpe,sucovpe]=spredict(pass,train,test,sneipe,scorpe,si,k,w,d);
        [Ucoverage] = aggregation(Ucoverage,sucovpe,l,7,actmin,actmax);
        clear spredict aggregation;
%**************************************************************************
        
%**************************************************************************
    
%         for rec=minrec:maxrec
% %--------------------------------------------------------------------------
%             Urecall(actmin:actmax,1,rec,l)=(actmin:actmax)';
%             Uprec(actmin:actmax,1,rec,l)=(actmin:actmax)';
%             Ufpr(actmin:actmax,1,rec,l)=(actmin:actmax)';
% % =========================================================================
% %             [recmndms] = recmnd(predms,rec,nrr,w);
% %             clear recmnd;
%             [recmndcos] = recmnd(predcos,rec,nrr,w);
%             clear recmnd;
%             [recmndpe] = recmnd(predpe,rec,nrr,w);
%             clear recmnd;
%             %==============================================================
% %             [srecmndms] = recmnd(spredms,rec,nrr,w);
% %             clear recmnd;
%             [srecmndcos] = recmnd(spredcos,rec,nrr,w);
%             clear recmnd;
%             [srecmndpe] = recmnd(spredpe,rec,nrr,w);
%             clear recmnd;
% % =========================================================================
% %             [Precms,Recallms,FPRms,uprecms,urecallms,ufprms] = PrecRec(recmndms,test,predms,nrr,w,d);
% %             [Urecall]=aggregation2(Urecall,urecallms,l,2,rec,actmin,actmax);
% %             [Uprec]=aggregation2(Uprec,uprecms,l,2,rec,actmin,actmax);
% %             [Ufpr]=aggregation2(Ufpr,ufprms,l,2,rec,actmin,actmax);
% %             clear PrecRec aggregation2;
%             
%             [Preccos,Recallcos,FPRcos,upreccos,urecallcos,ufprcos] = PrecRec(recmndcos,test,predcos,nrr,w,d);
%             [Urecall]=aggregation2(Urecall,urecallcos,l,3,rec,actmin,actmax);
%             [Uprec]=aggregation2(Uprec,upreccos,l,3,rec,actmin,actmax);
%             [Ufpr]=aggregation2(Ufpr,ufprcos,l,3,rec,actmin,actmax);
%             clear PrecRec aggregation2;
%             
%             [Precpe,Recallpe,FPRpe,uprecpe,urecallpe,ufprpe] = PrecRec(recmndpe,test,predpe,nrr,w,d);
%             [Urecall]=aggregation2(Urecall,urecallpe,l,4,rec,actmin,actmax);
%             [Uprec]=aggregation2(Uprec,uprecpe,l,4,rec,actmin,actmax);
%             [Ufpr]=aggregation2(Ufpr,ufprpe,l,4,rec,actmin,actmax);
%             clear PrecRec aggregation2;
%             %==============================================================
% %             [SPrecms,SRecallms,SFPRms,suprecms,surecallms,sufprms] = SPrecRec(srecmndms,test,spredms,stru,si,nrr,w,d);
% %             [Urecall]=aggregation2(Urecall,surecallms,l,5,rec,actmin,actmax);
% %             [Uprec]=aggregation2(Uprec,suprecms,l,5,rec,actmin,actmax);
% %             [Ufpr]=aggregation2(Ufpr,sufprms,l,5,rec,actmin,actmax);
% %             clear SPrecRec aggregation2;
%             
%             [SPreccos,SRecallcos,SFPRcos,supreccos,surecallcos,sufprcos] = SPrecRec(srecmndcos,test,spredcos,stru,si,nrr,w,d);
%             [Urecall]=aggregation2(Urecall,surecallcos,l,6,rec,actmin,actmax);
%             [Uprec]=aggregation2(Uprec,supreccos,l,6,rec,actmin,actmax);
%             [Ufpr]=aggregation2(Ufpr,sufprcos,l,6,rec,actmin,actmax);
%             clear SPrecRec aggregation2;
%             
%             [SPrecpe,SRecallpe,SFPRpe,suprecpe,surecallpe,sufprpe] = SPrecRec(srecmndpe,test,spredpe,stru,si,nrr,w,d);
%             [Urecall]=aggregation2(Urecall,surecallpe,l,7,rec,actmin,actmax);
%             [Uprec]=aggregation2(Uprec,suprecpe,l,7,rec,actmin,actmax);
%             [Ufpr]=aggregation2(Ufpr,sufprpe,l,7,rec,actmin,actmax);
%             clear SPrecRec aggregation2;
% % =========================================================================
% % *************************************************************************
%             if rec ~= maxrec
%                 precision(((l-1) * maxrec) + rec,1) = precision(((l-1) * maxrec) + rec,1) + k;
%                 precision(((l-1) * maxrec) + rec,2) = precision(((l-1) * maxrec) + rec,2) + rec;
%                 
% %                 precision(((l-1) * maxrec) + rec,3) = precision(((l-1) * maxrec) + rec,3) + (SPrecms - Precms);
%                 precision(((l-1) * maxrec) + rec,4) = precision(((l-1) * maxrec) + rec,4) + (SPreccos - Preccos);
%                 precision(((l-1) * maxrec) + rec,5) = precision(((l-1) * maxrec) + rec,5) + (SPrecpe - Precpe);
%   		% ***----------------------------*** %
%                 Recall(((l-1) * maxrec) + rec,1) =  Recall(((l-1) * maxrec) + rec,1) + k;
%                 Recall(((l-1) * maxrec) + rec,2) =  Recall(((l-1) * maxrec) + rec,2) + rec;
%                 
% %                 Recall(((l-1) * maxrec) + rec,3) =  Recall(((l-1) * maxrec) + rec,3) + (SRecallms -  Recallms);
%                 Recall(((l-1) * maxrec) + rec,4) =  Recall(((l-1) * maxrec) + rec,4) + (SRecallcos -  Recallcos);
%                 Recall(((l-1) * maxrec) + rec,5) =  Recall(((l-1) * maxrec) + rec,5) + (SRecallpe -  Recallpe);
%         % ***------------------------------------------------------*** %
%                 Aprecision(((l-1) * maxrec) + rec,1) = Aprecision(((l-1) * maxrec) + rec,1) + k;
%                 Aprecision(((l-1) * maxrec) + rec,2) = Aprecision(((l-1) * maxrec) + rec,2) + rec;
%                 
% %                 Aprecision(((l-1) * maxrec) + rec,3) = Aprecision(((l-1) * maxrec) + rec,3) + Precms;
%                 Aprecision(((l-1) * maxrec) + rec,4) = Aprecision(((l-1) * maxrec) + rec,4) + Preccos;
%                 Aprecision(((l-1) * maxrec) + rec,5) = Aprecision(((l-1) * maxrec) + rec,5) + Precpe;
%                 
% %                 Aprecision(((l-1) * maxrec) + rec,6) = Aprecision(((l-1) * maxrec) + rec,6) + SPrecms;
%                 Aprecision(((l-1) * maxrec) + rec,7) = Aprecision(((l-1) * maxrec) + rec,7) + SPreccos;
%                 Aprecision(((l-1) * maxrec) + rec,8) = Aprecision(((l-1) * maxrec) + rec,8) + SPrecpe;
%                 
%         % ***----------------------------*** %  
%                 ARecall(((l-1) * maxrec) + rec,1) =  ARecall(((l-1) * maxrec) + rec,1) + k;
%                 ARecall(((l-1) * maxrec) + rec,2) =  ARecall(((l-1) * maxrec) + rec,2) + rec;
%                 
% %                 ARecall(((l-1) * maxrec) + rec,3) =  ARecall(((l-1) * maxrec) + rec,3) + Recallms;
%                 ARecall(((l-1) * maxrec) + rec,4) =  ARecall(((l-1) * maxrec) + rec,4) + Recallcos;
%                 ARecall(((l-1) * maxrec) + rec,5) =  ARecall(((l-1) * maxrec) + rec,5) + Recallpe;
%                 
% %                 ARecall(((l-1) * maxrec) + rec,6) =  ARecall(((l-1) * maxrec) + rec,6) + SRecallms;
%                 ARecall(((l-1) * maxrec) + rec,7) =  ARecall(((l-1) * maxrec) + rec,7) + SRecallcos;
%                 ARecall(((l-1) * maxrec) + rec,8) =  ARecall(((l-1) * maxrec) + rec,8) + SRecallpe;
%                 
%         % ***----------------------------*** %        
%                 AFPR(((l-1) * maxrec) + rec,1) =  AFPR(((l-1) * maxrec) + rec,1) + k;
%                 AFPR(((l-1) * maxrec) + rec,2) =  AFPR(((l-1) * maxrec) + rec,2) + rec;
%                
% %                 AFPR(((l-1) * maxrec) + rec,3) =  AFPR(((l-1) * maxrec) + rec,3) + FPRms;
%                 AFPR(((l-1) * maxrec) + rec,4) =  AFPR(((l-1) * maxrec) + rec,4) + FPRcos;
%                 AFPR(((l-1) * maxrec) + rec,5) =  AFPR(((l-1) * maxrec) + rec,5) + FPRpe;
%                
% %                 AFPR(((l-1) * maxrec) + rec,6) =  AFPR(((l-1) * maxrec) + rec,6) + SFPRms;
%                 AFPR(((l-1) * maxrec) + rec,7) =  AFPR(((l-1) * maxrec) + rec,7) + SFPRcos;
%                 AFPR(((l-1) * maxrec) + rec,8) =  AFPR(((l-1) * maxrec) + rec,8) + SFPRpe;
% % =========================================================================
%                 clear Precms Preccos Precpe Recallms Recallcos Recallpe FPRms FPRcos FPRpe;
%                 clear SPrecms SPreccos SPrecpe SRecallms SRecallcos SRecallpe SFPRms SFPRcos SFPRpe ;
%                 clear uprecms urecallms ufprms upreccos urecallcos ufprcos uprecpe urecallpe ufprpe;
%                 clear suprecms surecallms sufprms supreccos surecallcos sufprcos suprecpe surecallpe sufprpe;
% % =========================================================================
% % *************************************************************************
%             else
%                 precision(((l-1) * maxrec) + rec,1) = precision(((l-1) * maxrec) + rec,1) + k;
%                 precision(((l-1) * maxrec) + rec,2) = precision(((l-1) * maxrec) + rec,2) + rec;
%                 
% %                 precision(((l-1) * maxrec) + rec,3) = precision(((l-1) * maxrec) + rec,3) + (SPrecms - Precms);
%                 precision(((l-1) * maxrec) + rec,4) = precision(((l-1) * maxrec) + rec,4) + (SPreccos - Preccos);
%                 precision(((l-1) * maxrec) + rec,5) = precision(((l-1) * maxrec) + rec,5) + (SPrecpe - Precpe);
%   		% ***----------------------------*** %
%                 Recall(((l-1) * maxrec) + rec,1) =  Recall(((l-1) * maxrec) + rec,1) + k;
%                 Recall(((l-1) * maxrec) + rec,2) =  Recall(((l-1) * maxrec) + rec,2) + rec;
%                 
% %                 Recall(((l-1) * maxrec) + rec,3) =  Recall(((l-1) * maxrec) + rec,3) + (SRecallms -  Recallms);
%                 Recall(((l-1) * maxrec) + rec,4) =  Recall(((l-1) * maxrec) + rec,4) + (SRecallcos -  Recallcos);
%                 Recall(((l-1) * maxrec) + rec,5) =  Recall(((l-1) * maxrec) + rec,5) + (SRecallpe -  Recallpe);
%         % ***------------------------------------------------------*** %
%                 Aprecision(((l-1) * maxrec) + rec,1) = Aprecision(((l-1) * maxrec) + rec,1) + k;
%                 Aprecision(((l-1) * maxrec) + rec,2) = Aprecision(((l-1) * maxrec) + rec,2) + rec;
%                 
% %                 Aprecision(((l-1) * maxrec) + rec,3) = Aprecision(((l-1) * maxrec) + rec,3) + Precms;
%                 Aprecision(((l-1) * maxrec) + rec,4) = Aprecision(((l-1) * maxrec) + rec,4) + Preccos;
%                 Aprecision(((l-1) * maxrec) + rec,5) = Aprecision(((l-1) * maxrec) + rec,5) + Precpe;
%                 
% %                 Aprecision(((l-1) * maxrec) + rec,6) = Aprecision(((l-1) * maxrec) + rec,6) + SPrecms;
%                 Aprecision(((l-1) * maxrec) + rec,7) = Aprecision(((l-1) * maxrec) + rec,7) + SPreccos;
%                 Aprecision(((l-1) * maxrec) + rec,8) = Aprecision(((l-1) * maxrec) + rec,8) + SPrecpe;
%                 
%         % ***----------------------------*** %
%                 ARecall(((l-1) * maxrec) + rec,1) =  ARecall(((l-1) * maxrec) + rec,1) + k;
%                 ARecall(((l-1) * maxrec) + rec,2) =  ARecall(((l-1) * maxrec) + rec,2) + rec;
%                 
% %                 ARecall(((l-1) * maxrec) + rec,3) =  ARecall(((l-1) * maxrec) + rec,3) + Recallms;
%                 ARecall(((l-1) * maxrec) + rec,4) =  ARecall(((l-1) * maxrec) + rec,4) + Recallcos;
%                 ARecall(((l-1) * maxrec) + rec,5) =  ARecall(((l-1) * maxrec) + rec,5) + Recallpe;
%                 
% %                 ARecall(((l-1) * maxrec) + rec,6) =  ARecall(((l-1) * maxrec) + rec,6) + SRecallms;
%                 ARecall(((l-1) * maxrec) + rec,7) =  ARecall(((l-1) * maxrec) + rec,7) + SRecallcos;
%                 ARecall(((l-1) * maxrec) + rec,8) =  ARecall(((l-1) * maxrec) + rec,8) + SRecallpe;
%                 
%        % ***----------------------------*** %         
%                 AFPR(((l-1) * maxrec) + rec,1) =  AFPR(((l-1) * maxrec) + rec,1) + k;
%                 AFPR(((l-1) * maxrec) + rec,2) =  AFPR(((l-1) * maxrec) + rec,2) + rec;
%                
% %                 AFPR(((l-1) * maxrec) + rec,3) =  AFPR(((l-1) * maxrec) + rec,3) + FPRms;
%                 AFPR(((l-1) * maxrec) + rec,4) =  AFPR(((l-1) * maxrec) + rec,4) + FPRcos;
%                 AFPR(((l-1) * maxrec) + rec,5) =  AFPR(((l-1) * maxrec) + rec,5) + FPRpe;
%                 
% %                 AFPR(((l-1) * maxrec) + rec,6) =  AFPR(((l-1) * maxrec) + rec,6) + SFPRms;
%                 AFPR(((l-1) * maxrec) + rec,7) =  AFPR(((l-1) * maxrec) + rec,7) + SFPRcos;
%                 AFPR(((l-1) * maxrec) + rec,8) =  AFPR(((l-1) * maxrec) + rec,8) + SFPRpe;
% % =========================================================================
%             end
%         end
%     
%==========================================================================
%         [maems,umaems] = MAE(predms,test,w,d);      
%         [Umae] = aggregation(Umae,umaems,l,2,actmin,actmax);
%         clear MAE aggregation;
        %------------------------------------------------------------------
        [maecos,umaecos]=MAE(predcos,test,w,d);
        [Umae] = aggregation(Umae,umaecos,l,3,actmin,actmax);
        clear MAE aggregation;
        %------------------------------------------------------------------
        [maepe,umaepe]=MAE(predpe,test,w,d);
        [Umae] = aggregation(Umae,umaepe,l,4,actmin,actmax);
        clear MAE aggregation;
        %==================================================================
%         [smaems,sumaems] = SMAE(spredms,test,stru,si,w,d);
%         [Umae] = aggregation(Umae,sumaems,l,5,actmin,actmax);
%         clear SMAE aggregation;
        %------------------------------------------------------------------
        [smaecos,sumaecos]=SMAE(spredcos,test,stru,si,w,d);
        [Umae] = aggregation(Umae,sumaecos,l,6,actmin,actmax);
        clear SMAE aggregation;
        %------------------------------------------------------------------
        [smaepe,sumaepe]=SMAE(spredpe,test,stru,si,w,d);
        [Umae] = aggregation(Umae,sumaepe,l,7,actmin,actmax);
        clear SMAE aggregation;  
%==========================================================================
        if k ~= maxk
            clear neims neicos neipe predms predcos predpe recmndms recmndcos recmndpe;
            clear sneims sneicos sneipe spredms spredcos spredpe srecmndms srecmndcos srecmndpe;
%--------------------------------------------------------------------------
            coverage(l,1) = coverage(l,1) + k;
            
%             coverage(l,2) = coverage(l,2) + (scovms - covms) ;
            coverage(l,3) = coverage(l,3) + (scovcos - covcos) ;
            coverage(l,4) = coverage(l,4) + (scovpe - covpe) ;
            
      % ***----------------------------*** %
            MAERROR(l,1) = MAERROR(l,1) + k;
            
%             MAERROR(l,2) = MAERROR(l,2) + (maems - smaems) ;
            MAERROR(l,3) = MAERROR(l,3) + (maecos - smaecos) ;
            MAERROR(l,4) = MAERROR(l,4) + (maepe - smaepe) ;
      % ***------------------------------------------------------*** %
            Acoverage(l,1) = Acoverage(l,1) + k;
            
%             Acoverage(l,2) = Acoverage(l,2) + covms ;
            Acoverage(l,3) = Acoverage(l,3) + covcos ;
            Acoverage(l,4) = Acoverage(l,4) + covpe ;
            
%             Acoverage(l,5) = Acoverage(l,5) + scovms ;
            Acoverage(l,6) = Acoverage(l,6) + scovcos ;
            Acoverage(l,7) = Acoverage(l,7) + scovpe ;
            
      % ***----------------------------*** %       
            AMAERROR(l,1) = AMAERROR(l,1) + k;
            
%             AMAERROR(l,2) = AMAERROR(l,2) + maems ;
            AMAERROR(l,3) = AMAERROR(l,3) + maecos ;
            AMAERROR(l,4) = AMAERROR(l,4) + maepe ;
           
%             AMAERROR(l,5) = AMAERROR(l,5) + smaems ;
            AMAERROR(l,6) = AMAERROR(l,6) + smaecos ;
            AMAERROR(l,7) = AMAERROR(l,7) + smaepe ;
            
            disp(r); %**%
            disp(k); %**%
%--------------------------------------------------------------------------
            clear  covms covcos covpe maems maecos maepe ;
            clear  scovms scovcos scovpe smaems smaecos smaepe;
            clear  umaems umaecos umaepe sumaems sumaecos sumaepe;
            clear  ucovms ucovcos ucovpe sucovms sucovcos sucovpe;
%==========================================================================
        else
            coverage(l,1) = coverage(l,1) + k;
            
%             coverage(l,2) = coverage(l,2) + (scovms - covms) ;
            coverage(l,3) = coverage(l,3) + (scovcos - covcos) ;
            coverage(l,4) = coverage(l,4) + (scovpe - covpe) ;
            
      % ***----------------------------*** %  
            MAERROR(l,1) = MAERROR(l,1) + k;
%             MAERROR(l,2) = MAERROR(l,2) + (maems - smaems) ;
            MAERROR(l,3) = MAERROR(l,3) + (maecos - smaecos) ;
            MAERROR(l,4) = MAERROR(l,4) + (maepe - smaepe) ;
      % ***------------------------------------------------------*** %     
            Acoverage(l,1) = Acoverage(l,1) + k;
            
%             Acoverage(l,2) = Acoverage(l,2) + covms ;
            Acoverage(l,3) = Acoverage(l,3) + covcos ;
            Acoverage(l,4) = Acoverage(l,4) + covpe ;
            
%             Acoverage(l,5) = Acoverage(l,5) + scovms ;
            Acoverage(l,6) = Acoverage(l,6) + scovcos ;
            Acoverage(l,7) = Acoverage(l,7) + scovpe ;
            
      % ***----------------------------*** %       
            AMAERROR(l,1) = AMAERROR(l,1) + k;
            
%             AMAERROR(l,2) = AMAERROR(l,2) + maems ;
            AMAERROR(l,3) = AMAERROR(l,3) + maecos ;
            AMAERROR(l,4) = AMAERROR(l,4) + maepe ;
            
%             AMAERROR(l,5) = AMAERROR(l,5) + smaems ;
            AMAERROR(l,6) = AMAERROR(l,6) + smaecos ;
            AMAERROR(l,7) = AMAERROR(l,7) + smaepe ;
            
            disp(r); %**%
            disp(k); %**%
        end
%==========================================================================
    end
%--------------------------------------------------------------------------
end
coverage = coverage(:,:) / crv;
MAERROR = MAERROR(:,:) / crv;
% precision = precision(:,:) / (crv);
% Recall = Recall(:,:) / (crv);

Acoverage = Acoverage(:,:) / crv;
AMAERROR = AMAERROR(:,:) / crv;
% Aprecision = Aprecision(:,:) / (crv);
% ARecall = ARecall(:,:) / (crv);
% AFPR = AFPR(:,:) / (crv);
% [AFmeas] = FMeasure(AFmeas,Aprecision,ARecall,maxk/step,maxrec);

total=toc;