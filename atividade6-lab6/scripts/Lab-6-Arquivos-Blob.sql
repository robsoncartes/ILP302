CREATE OR REPLACE PROCEDURE load_image_to_blob_column(p_blob_id INTEGER, p_directory VARCHAR2, p_file_name VARCHAR2) AS
  v_file UTL_FILE.FILE_TYPE;
  v_bytes_read INTEGER;
  v_dest_blob BLOB;
  v_amount INTEGER := 32767;
  v_binary_buffer RAW(32767);
BEGIN
  -- inseri um BLOB vazio
  INSERT INTO blob_content(id, blob_column) VALUES (p_blob_id, EMPTY_BLOB());
  SELECT blob_column INTO v_dest_blob FROM blob_content WHERE id = p_blob_id FOR UPDATE;
  v_file := UTL_FILE.FOPEN(p_directory, p_file_name, 'rb', v_amount); -- abre o arquivo para leitura de bytes (v_amount bytes por vez)

  LOOP -- copia os dados do arquivo para a blob de destino
    BEGIN
      UTL_FILE.GET_RAW(v_file, v_binary_buffer, v_amount); -- leitura binaria dos dados a partir do arquivo para a o buffer
      v_bytes_read := LENGTH(v_binary_buffer);
      DBMS_LOB.WRITEAPPEND(v_dest_blob, v_bytes_read/2, v_binary_buffer); -- faz um append v_binary_buffer para o blob
    EXCEPTION
      WHEN NO_DATA_FOUND THEN -- quando não há mais dados no arquivo então sai
        EXIT;
    END;
  END LOOP;

  UTL_FILE.FCLOSE(v_file);   -- fecha o arquivo
  DBMS_OUTPUT.PUT_LINE('Tamanho em bytes: ' || v_bytes_read / 2);
  DBMS_OUTPUT.PUT_LINE('Arquivo copiado com sucesso.');
END load_image_to_blob_column;
/

-- SELECT LENGTH(blob_column) FROM blob_content WHERE id = 1;