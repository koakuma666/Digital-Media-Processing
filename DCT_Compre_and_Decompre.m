function Tout = DCT_Compre_and_Decompre(I, x, y, Quan_table)
% This is the code of Compression and Decompression image using DCT and two different quantisation tables 
% - to quantize Luminance and Chrominance variables
    for x = 1:64
        for y = 1:64
            
            %Start of Compression Process 
            lena = I((x - 1) * 8 + 1 : (x - 1) * 8 + 8, (y - 1) * 8 + 1 :(y - 1) * 8 + 8); %extract 8x8 pixel block from the image 
            Matrix_center = lena - 128;  %center matrix over zero 
            Trans_Matrix = dct2(Matrix_center); %Apply the 2D-DCT, then Trans_Matrix is the transform matrix 
            Comp_Trans_Matrix = round(Trans_Matrix ./ Quan_table); %replace Trans_Matrix by the compressed matrix (Quantized using Quan_table) 

            %Start of Decompression Process
            Comp_Trans_Matrix_dq = Comp_Trans_Matrix .* Quan_table; %dequantization 
            X_dq = idct2(Comp_Trans_Matrix_dq); %inverse DCT transform 
            X_un_center = X_dq + 128; %un-center the matrix 
            Tout((x - 1) * 8 + 1 : ( x - 1) * 8 + 8,(y - 1) * 8 + 1 : ( y - 1) * 8 + 8) = X_un_center;
        end
    end
end