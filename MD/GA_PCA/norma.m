%  NORMIROWANIE OSWIETLENIA
%  G. Kuchariew

function obraz_norm=norma(obraz)


[m,n]=size(obraz);
sr=mean2(obraz);
b=sqrt(sum((obraz(:)-sr).^2)/(m*n));

      x=(obraz-sr)/b;
      
      mia = min(min(x));
      mab = max(max(x));  
      obraz_norm = fix(255*(x-mia)/(mab-mia)+1); 
      
