CREATE OR REPLACE VIEW dkim AS
 SELECT admin_domain.id,
    admin_domain.name AS domain_name,
    admin_domain.dkim_private_key_path AS private_key_path,
    admin_domain.dkim_key_selector AS selector
   FROM admin_domain
  WHERE admin_domain.enable_dkim;
GRANT SELECT ON dkim TO opendkim;
