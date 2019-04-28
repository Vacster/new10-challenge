/**
 * A helper class to generate a valid 36-Character UUID
 */
public without sharing class UUIDHelper {
    
    /**
     * Generates a valid UUID v4 (Random) with the exception of the reserved bits
     * that specify the version as they are out of the scope of this project.
     * @return   A 36-Character String with the valid UUID
     */
    public static String generateUUID() {
        Blob aesKeyBlob = Crypto.GenerateAESKey(128);
        String hex = EncodingUtil.ConvertTohex(aesKeyBlob);
        String guid = hex.SubString(0,8) + '-' 
                        + hex.SubString(8,12) + '-' + hex.SubString(12,16) + '-' 
                        + hex.SubString(16,20) + '-' + hex.substring(20);

        return guid;
    }

}
