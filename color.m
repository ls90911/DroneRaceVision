



img = zeros(256,256,3);


figure(1)

for y=1:16
    for U=1:256
        for V=1:256
            
            Y = y*16-8;
            
            R = Y + 1.4075 * (V - 128);
            G = Y - 0.3455 * (U - 128) - (0.7169 * (V - 128));
            B = Y + 1.7790 * (U - 128);
            
            if R<1
                R=1;
            end
            if R>256
                R=256;
            end
            if G<1
                G=1;
            end
            if G>256
                G=256;
            end
            if B<1
                B=1;
            end
            if B>256
                B=256;
            end
            
            M = max([R,G,B]);
            m = min([R,G,B]);
            
            C = M-m;
            
            if M <1
                S = 0
            else
                S = C/M;
            end
            
            if M == R
                H = mod((G-B)/C, 6);
            elseif M == G
                H = (B-R)/C + 2;
            elseif M == B
                H = (R-G)/C + 4;
            else
                H = 0;
            end
            
            I = (R+G+B)/3;
            
            H = H / 6;
            % H 0. 0.15  0.85 - 1
            % S > 0.15
            
            if  (I <= 240) & (I > 30) & (S > 0.20) & ((H<0.10) | (H>0.85))
%            if  (M < 240) & (S > 0.3) & (M > 75) & ((H<0.15) | (H>0.85))
            else
                R = 256;
                G = 256;
                B = 256;
            end
            
            img(U,V,1) = R / 256;
            img(U,V,2) = G / 256;
            img(U,V,3) = B / 256;
        end
    end
    subplot(4,4,y)
    imshow(img)
    %xlabel('u')
    %ylabel('v')
    title(['Y=' num2str(Y)])
    
end


% 
% cr > 140
% dy + 0.5
% dy / 10
% 
% dy > 0.55
