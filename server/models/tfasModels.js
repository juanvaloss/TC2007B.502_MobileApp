const { supabase } = require('../config/db'); 

const assignCodetoUser = async(userId, otpCode) =>{
    try {
        const { error } = await supabase
          .from('tfaUsers')
          .insert([{belongsTo: userId, code: otpCode}])
          .select('*');
        
        if (error) {
            throw new Error(`Error executing query: ${error.message}`);
        }
    
        return true;
    } catch (err) {
        console.error('Error assigning code:', err);
        return false;
    }
}

const assignCodetoAdmin = async(adminId, otpCode) =>{
  try {
      const { error } = await supabase
        .from('tfaAdmins')
        .insert([{belongsTo: adminId, code: otpCode}])
        .select('*');
      
      if (error) {
          throw new Error(`Error executing query: ${error.message}`);
      }
  
      return true;
  } catch (err) {
      console.error('Error assigning code:', err);
      return false;
  }
}

const getLatestCodeUser = async(userId) =>{
    try {
        const { data, error } = await supabase
          .from('tfaUsers')
          .select('code, createdAt')
          .eq('belongsTo', userId)
          .order('createdAt', { ascending: false })
          .limit(1);
        
        if (error) {
          throw new Error(`Error executing query: ${error.message}`);
        }
    
        return data[0];
    } catch (err) {
        console.error('Error creating request:', err);
        throw err;
    }
}

const getLatestCodeAdmin = async(userId) =>{
  try {
      const { data, error } = await supabase
        .from('tfaAdmins')
        .select('code, createdAt')
        .eq('belongsTo', userId)
        .order('createdAt', { ascending: false })
        .limit(1);
      
      if (error) {
        throw new Error(`Error executing query: ${error.message}`);
      }
  
      return data[0];
  } catch (err) {
      console.error('Error creating request:', err);
      throw err;
  }
}

const eraseAllUserCodes = async(userId) =>{
    try {
        const { data, error } = await supabase
          .from('tfaUsers')
          .delete()
          .eq('belongsTo', userId)
          .select('*');
    
        if (error) {
          console.error('Error deleting user codes:', error);
          return false;
        }
    
        if (!data || data.length === 0) {
          console.warn('No codes found to delete.');
          return false;
        }
    
        return true;
      } catch (err) {
        console.error('Error in eraseAllUserCodes:', err);
        return false;
      }
}

const eraseAllAdminCodes = async(userId) =>{
  try {
      const { data, error } = await supabase
        .from('tfaAdmins')
        .delete()
        .eq('belongsTo', userId)
        .select('*');
  
      if (error) {
        console.error('Error deleting user codes:', error);
        return false;
      }
  
      if (!data || data.length === 0) {
        console.warn('No codes found to delete.');
        return false;
      }
  
      return true;
    } catch (err) {
      console.error('Error in eraseAllUserCodes:', err);
      return false;
    }
}

module.exports = {getLatestCodeUser, getLatestCodeAdmin, assignCodetoUser, assignCodetoAdmin, eraseAllUserCodes, eraseAllAdminCodes}; 