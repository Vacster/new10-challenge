public without sharing class UUIDHelper {
    
    public static String generateUUID() {
        Blob aesKeyBlob = Crypto.GenerateAESKey(128);
        String hex = EncodingUtil.ConvertTohex(aesKeyBlob);
        String guid = hex.SubString(0,8) + '-' 
                        + hex.SubString(8,12) + '-' + hex.SubString(12,16) + '-' 
                        + hex.SubString(16,20) + '-' + hex.substring(20);

        return guid;
    }

}
