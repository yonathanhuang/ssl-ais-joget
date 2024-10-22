package com.joget.ssl;

import org.joget.apps.app.service.AppUtil;
import org.joget.apps.userview.model.UserviewMenu;
import org.joget.plugin.base.PluginManager;
import org.springframework.context.ApplicationContext;

import java.util.HashMap;
import java.util.Map;

public class AISMenu extends UserviewMenu {
    @Override
    public String getCategory() {
        return "SSL";
    }

    @Override
    public String getIcon() {
        return null;
    }

    @Override
    public String getRenderPage() {
        Map<String, Object> dataModel = new HashMap<String, Object>();

        ApplicationContext appContext    = AppUtil.getApplicationContext();
        PluginManager pluginManager = (PluginManager) appContext.getBean("pluginManager");

        dataModel.put("googleAPIURL", getPropertyString("googleAPIURL"));

        String htmlContent = pluginManager.getPluginFreeMarkerTemplate(dataModel, getClassName(), "/templates/aisMenu.ftl", "");
        return htmlContent;
    }

    @Override
    public boolean isHomePageSupported() {
        return true;
    }

    @Override
    public String getDecoratedMenu() {
        return null;
    }

    @Override
    public String getName() {
        return "SSL-AIS Menu";
    }

    @Override
    public String getVersion() {
        return getClass().getPackage().getImplementationVersion();
    }

    @Override
    public String getDescription() {
        return "Get Maritime Information from AIS";
    }

    @Override
    public String getLabel() {
        return this.getName();
    }

    @Override
    public String getClassName() {
        return this.getClass().getName();
    }

    @Override
    public String getPropertyOptions() {
        return AppUtil.readPluginResource(getClass().getName(), "/properties/aisMenu.json", null, true, "");
    }
}
