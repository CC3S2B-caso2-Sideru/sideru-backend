package com.sideru.sideru_backend.config;

import org.hibernate.boot.model.TypeContributions;
import org.hibernate.dialect.H2Dialect;
import org.hibernate.service.ServiceRegistry;
import org.hibernate.type.SqlTypes;
import org.hibernate.type.descriptor.sql.internal.DdlTypeImpl;
import org.hibernate.type.descriptor.jdbc.VarcharJdbcType;

public class CustomH2Dialect extends H2Dialect {

    @Override
    protected void registerColumnTypes(TypeContributions typeContributions, ServiceRegistry serviceRegistry) {
        super.registerColumnTypes(typeContributions, serviceRegistry);
        
        typeContributions.getTypeConfiguration().getDdlTypeRegistry()
            .addDescriptor(SqlTypes.NAMED_ENUM, new DdlTypeImpl(
                SqlTypes.NAMED_ENUM, 
                "varchar(255)", 
                this
            ));
            
        typeContributions.getTypeConfiguration().getJdbcTypeRegistry()
            .addDescriptor(SqlTypes.NAMED_ENUM, VarcharJdbcType.INSTANCE);
    }
}
