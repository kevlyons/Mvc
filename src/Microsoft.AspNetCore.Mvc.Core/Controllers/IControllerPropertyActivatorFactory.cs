// Copyright (c) .NET Foundation. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;

namespace Microsoft.AspNetCore.Mvc.Controllers
{
    public interface IControllerPropertyActivator
    {
        void Activate(ControllerContext context, object controller);

        Action<ControllerContext, object> GetActivatorDelegate(ControllerActionDescriptor actionDescriptor);
    }
}
