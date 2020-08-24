function enc_key = enkey;
  if enc_key < 0 || enc_key > 9999999999
       error('Invalid Key Selection');
  end
  enc_key = uint8(enc_key);