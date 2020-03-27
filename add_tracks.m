function s = add_tracks(filename,d, id_offset)

%% add_tracks - Analyzes songs and stores its hashes in a database.
%
% s = add_tracks(filename, d, id_offset)
%
% Esta funcion lee el archivo llamado filename, el cual contiene la informacion acerca de las
% canciones que queremos guardar en la base de datos d, procesarlas y almacenarlas.
%
% El archivo que se lee debe tener el siguiente formato: tener una fila para cada canci�n.
% En cada fila estar� la ubicaci�n del archivo mp3 a leer, el nombre de la cancion y el grupo que la 
% interpreta. Cada parte de informaci�n debe estar separadas de las dem�s
% con un '---'.
%
% EXAMPLE: Canciones/Target/Wonderwall.mp3---Oasis
%
% add_tracks tendr� como salida una matriz con la informacion de cada cancion guardada. Adem�s,
% la almacenar� en la base de datos. 
%
% id_offset indica a partir de qu� n�mero hay que empezar a contar el id de
% las canciones que se a�adan

% @authors: Danilo Serna, Carlos V�lez

% Preparing the variables
detalles = textread(filename,'%s');
l = length(detalles);
dilate_size = [20, 20];

s = cell(l, 1);
% Reading the file and obtaining the song information
for i = 1:l
    s{i,:} = detalles{i};
end

% Processing the songs
for i = 1:l

    % We read the song and convert it to its 8 KHz mono version
    [c, fs] = audioread(s{i,1}); 
    cMono = 0.5*(c(:,1) + c(:,2)); 
    c8000 = resample (cMono, 8000, fs);
    
    % Finding the landmarks and storing its hashes in the database
    [L, ~, ~] = find_landmarks(c8000, dilate_size);
    H = landmark2hash(L, i + id_offset);
    record_hashes(H,d);

    % Control output, used so we can check that everything is going well
    disp('Leido')
    fprintf('N�mero de hashes de la canci�n %d: %d\n',i, length(H))
    
    % Freeing up memory
    clear c cMono c8000 L S maxes H
end
