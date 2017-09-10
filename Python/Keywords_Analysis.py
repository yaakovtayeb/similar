import pandas as pd

def findparameters(landingpage):
    # input - landing page, output array of params
    if landingpage.find("?") > -1:
        parameters = landingpage[landingpage.find("?") + 1:]
        parameters = parameters.split("&")
        parameters = map(lambda x: x.split("=")[0], parameters)
    else:
        parameters = []
    return parameters

def removeTableName(data):
    cols = list()
    for n in data.columns.values:
        findit = n.find(".")+1
        cols.append(n[findit:len(n)])
    data.columns = cols

def cleanCommans(dataframe):
    for x in dataframe.columns.values:
        dataframe[x] = map(lambda x: x.replace(",", "") if type(x) is str else x, dataframe[x])
    return dataframe.apply(pd.to_numeric, errors="ignore")


# data = pd.read_clipboard(sep='\t')  # read from clipboard
path = "C:\Users\yaakov.tayeb\Documents\GitHub\similar\similar\Clients\compado.de1.tsv"
data = pd.read_csv(path, sep="\t", header=0)  # header is the line n or None
removeTableName(data)

gparam = ['17588969', '540519', 'ci_sku', 'ci_src', 'neids', 'slhyin-21', 'cadevice', 'hlpht', 'viphx', '1o2', 'SEM%7cG%7cBT1', 'obn', 'googinhydr18418-21', 'googinkenshoo-21', 'semcmpid', 'paid+search', 'google_pla_df', 'tgt_adv_XSG10001', 'df0', 'currencytype', '1s5', 'CAPCID', 'vpqr', 'uympq', 'catargetid', 'wt_gl', 'googshopfr-21', 'wl5', 'KPID', 'sem_b_goog', 'treatment_id', 'sem_8024046704_brand_goog', 'ul_noapp', '74204750545', 'GoogleShopping', 'useraquisition_9306101469', 'aw.ds', '2sid', 'm270.l1313', 'idsku', '_fromfsb', 'google_adwords', 's_kwa_pla', 'fantfootball-sem-goog-highperformance', 'GP_Search', 'jcmp', 'utm_custom1', '1s2', 'KNC-GoogleAdwords-PC', 'PLA15', 'rmatt', 'chn', 'pfx_google_roi', 'adwordsKeyword', 'adwordsAdgroupId', 'google-pla', 'kpid', 'adgrpID', 'codesf', '_utm_marilyn', '20141010', 'cpncode', '495624183850237', 'LGWCODE', '?xtor', 'Win10Upgrade_SEM_GOO_MSBranded_ACTV_en-US_windows%2010', 'extensionType', 'kwdID', '14110944', 'lsft', 'skwcid', '349530435146320', 'featuredproduct', 'featuredoption', 'loc:1', 'ref:212', 'refsmkt', 'CAGPSPN', 'external_id', 's_kenid', 'google_pla', 'dmi_buyer_kt', '202290', '7', 'Google_PLA', '311984label', 'network%3Dg%26matchtype%3Db%26target%3D%26source%3D%26adposition%3D1t1%26aceid%3D', 'ViewProductViaPortal', 'kwd_id', 'ploc', 'nxc', 'awkw', 'adp', 'sou', 'mpch', '2015_FFL_OffSearch_Phase2_Google_Branded_FantasyFootball', 'dropbox|e', 'tmskey', '1t1', 'utm_ag', '1t2', '779388832154023', '?cid', '1s4', 'CAWELAID', 'cvo_crid', 'placeholder', 'GoogleMS_BRc', 'Matchtype', 'gclid', 'wt.srch', '23394', 'parceiro_id', 'midia_id', '688451411226439', 'ISx20140327xNonBrand', 'pla:g', '22686', 'mm_campaign', '{product_id}', 'google_sem', 'c3api', 'googlebase', 'CS2-400001-%5bGOO%5d-%5b400001AB%5d-%5b%5d-%5b69497712617%5d-S-%5b%5d', 'content_mobile_8965229628_gmc_pla', 'network%3Dg%26matchtype%3De%26target%3D%26source%3D%26adposition%3D1t1%26aceid%3D', 'slga_pla', 'googleps', 'jcpid', 'Search_US_Google-Branded-Etsy-Brand-Exact', 'GS001', 't34_g_ls', 'pla_country', 'tztx', 'mplx', 'wt_snk', '1s3', 'advertiserid', 'wl4', 'PLGOOGLECPC', 'WWW_LP058_XXX_SEM-Brand_Google_ZZ_ZZ_T_Home', 'Name_Terms', 'cm_mmca3', 'goog_rb', 'cvo_campaign', '458206487572991', 'fpaffiliate', 'CMP_SKU', '_camp', 'Win10Upgrade_SEM_GOO_MSBranded_ACTV_en-US_sitelink', '_ad', '122550454579229', '338666', '_net', 'paid%20search', 'slga_x', 'Adwords', 'adID', 'UTM_Adgroupid', 'googleshopping', 'switchcurrency', 'DACH_brand', 'gaw', 'ReachLocal', 'chaseoffer', 'vkid', 'cgi_idsr_', '70405266031', '1s6', 'ex_cmp', 'pstid', 'psloc', 'goitab-21', '1o3', '74148', '24526', 'gsidynamic', 'etsy_exact', 'lbnetwork', 'lbkeyword', 'lbcreative', 'Brand_KOM%2Fbonprix+Allg.+Shop', 'marin', 'efkwid', 'pd_sl_781ozcfkw6_e', 'sc_campaign', 'bonprix%20online-shop', 'aip', '22698', 'uIv', 'cagpspn', '_tk', 'kispla', 'gshopping', 'kaClkId', 'googleproducts', 'earth_feed', 'tr_term', 'tr_campaign', 'tr_medium', 'tr_source', 'pla_health+beauty+shopping', '17pgs', 'googlesearch', '1o1', 'sc_channel', 'sc_country', 'hlSellerId', 'IDx20110310x00001i', 'sc_category', 'sc_publisher', 'sc_detail', 'BUSCADORES', '309654label', 'semcid', '303948label', '66852107312', 'wapr', 'ProspectID', 'sc_matchtype', '301584label', 'ws_tp1', '400279323408493', '8781787', 'sc_segment', 'google_shopping', 'parent_url', 'shoppingengine', 'affExtParam1', 'VEN1', 'sNCXi2uhP%7Cc%7C78819928442%7Ce%7Cfacebook%7C%7C8095dy448850', '78819928442', '1t3', 'jtid', 'sc_health+beauty', '_kenshoo_clickid_', 'pub_cr_id', 'Paid+Search+%e2%80%93+Brand', 'hrd', 'hc.aw.88.01', '77693971031', 'referer1', 'adw', 'CPNG', 'k_user_id', 's1YjVXPy5%7Cc%7C68678944596%7Ce%7Cfacebook%7C%7C8095fho40966', 'awdv', 'awnw', '68678944596', '1525132994376490', 'GoogleAds', 'google_base', '123134', 'om_mmc', 'sc_e', 'VEN2', 'tmad', 'utm_matchtype', '626177764180599', 'tmcampid', 'referer_id', 'shZrfNh2E_dc|pcrid|78580119669|pkw|bonprix%20online-shop|pmt|b', 'ts_code', 'SEABRAND_DE_de', 'referer2', 'a_pla_de_broad', 'KNC-DE0607PKW', 'mkt_id', 'kwds', 'dyn_id', '_rfa', 'sgg0y6GSF%7Cc%7C77693971031%7Ce%7Cfb%7C%7C8095pr940967', 'intel_term', 'google.adwords', 'AdWords_Brand', 'gclsrc', '2o1', 'bp_br_00_go_googlegrupobrand00027', '171153', 'cm_mmca2', 'froogle', 'googleads', '78820494602', 'sNCXi2uhP%7Cc%7C78820494602%7Ce%7Cfacebook%7C%7C8095dy448850', 'EMCID', 'MT_ID', 'us_search', 'offerpage', 'sem_non_brand', 'loc_physical_ms', 'sea.google%20trademark_', 'ADWORDS', 'pla', 'APID', 'OrderByTopSaleDESC', 'tr_content', 'CAMPAIGN', 'dfaid', 'KNC-C-HQ-NON-R-AC-NONE-NONE-2K0PX0-PX-GAW-71700000010306110', 'newly', 'wl1', 'wmtlabs', 'wl3', 'wl2', 'wl0', 'gcb', 'ADW', 'pfx', 'xiti', 'tgi', 'utm_agid', 'utm_kwid', 'google_s', 'jkId', 'YZMEZQ', 'foa', 'google_brand', 'F6liens-commerciaux', 'GCID', 'frontdoor', 'google_products', 'CSE', '_vsrefdom', 'cm_mmca4', 'geo_id', 'wt_sn', 'dynamic_proxy', 'rl_track_landing_pages', 'rl_key', 'c_dev', 'primary_serv', 'google_search', 'CMPID', '318615label', 'utm_creative', 'CS2-400001-%5bGOO%5d-%5b400001AB%5d-%5b%5d-%5b69258507257%5d-S-%5b%5d', '498913833573257', 'sdFf0JxG1%7Cc%7C77687701151%7Ce%7Cfacebook%7C%7C8095pr940967', '77687701151', '414359425376836', 'cm_mmca5', 'INST_Ponto_Frio', 'CMP_ID', 'cm_mmca6', 'reisen', '1s8', 'crdt', 'crlp', '71296622786', '7m3Xv2yo_dc', 'cc%2FHomepage+Test+-+Brand+-+Exact%2Fsea%2F7m3Xv2yo%2FChase+-+Only', 'PiID%5B%5D', 'Sok-Goog', 'GMD', 'tsa', 'eESource', 'googlesem', 'tv5monde_LSF-Sport-Football', 'AL3888368316922113egmercedes', 'advID', 'adtype', '6fLMNe3tDiNMDTlmgAgMbDdWfGEUdA', 'atrkid', 'bnrid', 'dsa', 'kcid', 'tmclickref', 'HTML5', 'INST_Institucional', 'countryview', 'afsrc', 'k_clickID', 'jap', 'sem-b-goog-de', 'BT_SC', 'DSA', 'tmplaceref', 'google-adwords', 'de12a999', 'googlebase-2010-07', 'adpos', 'k_clickid', 'mob', 'wmlspartner', 'BT_TRF', 'mpppc', 'reff', 'et_rp', 'channelref', 'DURL', '14pgs', 'pla_sports+shopping', 'mr:referralID', 'dclid', 'BT_MKWD', '18283950120', 'la%20banque%20postale', 'event_datum', 'WT.z_PC', 'c_aid', '9165952409', 'siomid', '_utmfs', '24538', '24731', '%2Bgry', 're_adpcnt', 'rmsrc', '492234', '376376label', '000-0001_notebooksbilliger_Exact', 'kampan', 'adcode', '439726229475291', 'id_producte', '___currency', 'vertriebsschluessel', 'gcp', 'WT.z_FT', 'ds_medium', 'aff_source', 'Click', 'acquisition', 'goog_w', '38200460', 'WT.z_PT', 'WT.z_DT', 'lpid', 'variation', 'netw', '376364label', 'sem_google_desktopbrandexact_cpc_google', 'GoogleAdwords', 'feedback_sha1', 'WT.z_KW', 'WT.z_KT', 'acnt', 'cre', 'KWID', '376381label', '406577002', 'gmc', 'AdKeyword', 'WT.z_MAT', 'cvsfe', 'cvsfhu', 'cvsfa', 'cm_mmca8', 'omniturecode', 'pscode', '1s7', 'portaldv', 'sPartner', 'crtv', 'Paid-AdWordsSearch-SEA-Brand', 'vendorCode', 'departure_fk', 'gadw', 'cse', 'ns_clid', 'pgc', 'CD951', 'e_9757003144_ing%20diba', 'isdl', 'aff_short_key', 'wt.z_kw', 'wt.z_cn', 'wt.z_ag', 'sem_google', 'psite', 'UneMJZVf', '_kk', 'is_id', 'Google-pla', 'Google%20PPC', 'dskwid', 'ib_id', 'refclickid', 'MDA', '309933', 'pla_with_promotion', 'premium_basic_1', '4309960053', 'Paid', 'showHotellistWithPromotion', '416642168442271', 'grubhub', '22722', '?utm_source', 'creativeASIN', 'gdftrk', 'vgs', 'google--g', 'ifr', 'DEFAULT_MAXDOME_PAKET_CAMPAIGN', 'slnk', 'albag', 'albch', 'p238%7CsHDfBErPI-dc_mtid_187079nc38483_pcrid_80815894999_', 'albcp', '-kw']

data["landingpage_params"] = map(lambda x: findparameters(x), data["landingpage"])
gpaid = []

for i in range(0, data["landingpage"].shape[0]):
    paid_params = sum(map(lambda x: x in gparam, data["landingpage"][i]))
    gpaid.append(paid_params)
data["gpaid"] = gpaid

pd.DataFrame({'keywords': data["landingpage"], 'paid': gpaid}).to_csv('paid_keywords.csv')


# displaying Traffic sources:
# data.loc[(data["traffic_source"]==1) & (data["gpaid"]>0), "traffic_source"] = 7
# for i in set(data["traffic_source"]):
#    print("Source %s: %.2f" % (i, len(data[data["traffic_source"]==i])/float(len(data))))

# pd.DataFrame(list(keyset)).to_clipboard(index=False,header=False)


